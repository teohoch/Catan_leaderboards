class Match < ApplicationRecord
  include ActiveModel::Validations
  has_many :user_matches, dependent: :destroy
  has_many :users, through: :user_matches
  belongs_to :tournament
  accepts_nested_attributes_for :user_matches
  validates :date, :location, client_presence: true


  def validated_human
    if self.validated
      I18n.t "positive"
    else
      I18n.t "negatory"
    end
  end

  def status
    self.validated ? (I18n.t :ended_f) : (I18n.t :waiting)
  end


  def validated_count
    self.user_matches.where(:validated => true).count
  end

  def validate_match
    if not self.validated and self.validated_count >= 2
      self.update(validated: true)
      not self.tournament_id.nil?
      user_matches = Match.set_rankings(self.user_matches, (self.tournament_id.nil?), (not self.tournament_id.nil?))

      user_matches = Match.set_victory_positions(user_matches)

      user_matches.sort_by! { |k| k.user_id }
      self.users.order(:id).zip user_matches.each do |user, ranking|
        user.increment(:matches_played)
        if self.tournament_id.nil?
          ranking[:elo_general] = user[:elo_general]
          user.increment(:elo_general, ranking[:elo_general_change])
        else
          ranking[:elo_general] = user[:elo_general]
          user.increment(:elo_general, ranking[:elo_general_change])
        end
        ranking[:elo_free] = user[:elo_free]
        user.increment(:elo_free, ranking[:elo_free_change])

        ranking.save
        user.save
      end
      if self.tournament_id.nil?
        User.update_position_general
      else
        User.update_position_tournament
      end
      User.update_position_free
    end
  end

  def self.new_with_child(match_params, tournament=false)
    @match = Match.new(:date => match_params[:date],
                       :location => match_params[:location],
                       :tournament_id => match_params[:tournament_id],
                       :round => match_params[:round])
    success = true
    error_list = []
    if @match.save
      elems_array = []
      match_params[:user_matches_attributes].each do |id, elem|
        a = UserMatch.new(:user_id => elem[:user_id],
                          :vp => elem[:vp],
                          :match_id => @match.id,
                          :validated => elem.key?(:validated) ? elem[:validated] : false)
        elems_array.push(a)
      end
      elems_array.each do |elem|
        unless elem.save
          error_list.push(elem.errors)
          success = false
          break
        end
      end
    else
      error_list.push(@match.errors)
      success = false
    end

    unless success
      @match.destroy
    end

    {:state => success, :errors => error_list, :object => (success ? @match : nil)}
  end

  def self.set_victory_positions(elems_array)
    elems_array.sort_by! { |k| k.vp.nil? ? -1 : k.vp }.reverse!
    counter = 1
    elems_array.each do |elem|
      elem.victory_position = counter
      counter = counter + 1
    end
    elems_array
  end

  def self.set_rankings(user_matches, general=false, tournament=false)
    attributes_general = []
    attributes_free = []
    attributes_tournament = []
    winner = true
    user_matches_ordered = user_matches.sort_by { |k| k.vp.nil? ? -1 : k.vp }.reverse!
    user_matches_ordered.each do |elem|
      elem_user = User.find(elem[:user_id])
      general ? attributes_general.push({:rating => elem_user.elo_general, :winner => winner, :provisional => (elem_user.matches_played<=2)}) : nil
      (general or tournament) ? attributes_free.push({:rating => elem_user.elo_free, :winner => winner, :provisional => (elem_user.matches_played<=2)}) : nil
      tournament ? attributes_tournament.push({:rating => elem_user.elo_tournament, :winner => winner, :provisional => (elem_user.matches_played<=2)}) : nil
      winner = false
    end

    if general
      calculator_general = Elo_Calculator.new(attributes_general)
      ratings_general = calculator_general.calculate_rating
      (0..(ratings_general.count-1)).each do |i|
        user_matches_ordered[i][:elo_general_change]=ratings_general[i]
      end
    end

    if general or tournament
      calculator_free = Elo_Calculator.new(attributes_free)
      ratings_free = calculator_free.calculate_rating
      (0..(ratings_free.count-1)).each do |i|
        user_matches_ordered[i][:elo_free_change]=ratings_free[i]
      end
    end

    if tournament
      calculator_tournament = Elo_Calculator.new(attributes_tournament)
      ratings_tournament = calculator_tournament.calculate_rating
      (0..(ratings_tournament.count-1)).each do |i|
        user_matches_ordered[i][:elo_tournament_change]=ratings_tournament[i]
      end
    end
    user_matches_ordered
  end


end


