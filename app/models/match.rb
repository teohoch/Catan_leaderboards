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

  def user_validation
    current_user_match = @match.user_matches.find_by_user_id(current_user.id)
    success = (not current_user_match.nil?)
    if success && current_user_match.update(:validated => true)
      @match.validate
    end
    success
  end

  def validate
    if not self.validated and self.validated_count >= 2
      self.update(validated: true)

      self.set_rankings
      self.set_victory_positions

      self.user_matches.each do |user_match|
        user = user_match.user
        user_match.update(:elo_general => user.elo_general, :elo_tournament => user.elo_tournament, :elo_free => user.elo_free)
        user.increment(:matches_played)
        user.increment(:elo_general, user_match[:elo_general_change])
        user.increment(:elo_tournament, user_match[:elo_tournament_change])
        user.increment(:elo_free, user_match[:elo_free_change])

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

  def set_victory_positions()
    user_matches = self.user_matches.order(vp: :desc)
    user_matches.each_with_index do |user_match, index|
      user_match.update(:victory_position => index)
    end
  end

  def set_rankings()
    general = self.tournament.nil?
    tournament = (not self.tournament.nil?)

    attributes_general = []
    attributes_free = []
    attributes_tournament = []
    winner = true
    user_matches_ordered = self.user_matches.order(vp: :desc)

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
      ratings_general.zip user_matches_ordered.each do |rating, user_match|
        user_match.update(:elo_general_change => rating)
      end
    end

    if general or tournament
      calculator_free = Elo_Calculator.new(attributes_free)
      ratings_free = calculator_free.calculate_rating
      ratings_free.zip user_matches_ordered.each do |rating, user_match|
        user_match.update(:elo_free_change => rating)
      end
    end

    if tournament
      calculator_tournament = Elo_Calculator.new(attributes_tournament)
      ratings_tournament = calculator_tournament.calculate_rating
      ratings_tournament.zip user_matches_ordered.each do |rating, user_match|
        user_match.update(:elo_tournament_change => rating)
      end
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


end


