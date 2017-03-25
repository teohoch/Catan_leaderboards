class Tournament < ApplicationRecord
  belongs_to :officer, :class_name => 'User'
  has_many :inscriptions
  has_many :users, through: :inscriptions
  has_many :matches
  attr_accessor :general_mode

  validates_presence_of :name, :number_players, :prize, :entrance_fee, :officer_id, :date, :rounds, :mode
  validates :board_size, inclusion: {in: [4,6]}
  validates :number_players, inclusion: {in: 3..16 }
  validates :mode, inclusion: { in: -1..5}

  def general_mode_human
    if self.mode == -1
      I18n.t 'tournamet_modes.free4all'
    else
      I18n.t 'tournamet_modes.pyramidal'
    end
  end

  def status_human
    case self.status
      when 0
        I18n.t 'register_phase'
      when 1
        I18n.t 'ongoing'
      when 2
        I18n.t 'finalized'
      else
        I18n.t 'invalid'
    end
  end

  def mode_human
    case self.mode
      when -1
        I18n.t 'tournamet_modes.free4all'
      when 0
        I18n.t 'tournamet_modes.instantwinner'
      when 1
        I18n.t 'tournamet_modes.onewinner'
      when 2
        I18n.t 'tournamet_modes.twowinner'
      when 3
        I18n.t 'tournamet_modes.threewinner'
      when 4
        I18n.t 'tournamet_modes.fourwinner'
      when 5
        I18n.t 'tournamet_modes.fivewinner'
      else
        I18n.t 'invalid'
    end
  end

  def start

    result = (self.mode ==-1) ? start_free4all : start_pyramidal

    if status
      self.status=1
      self.current_round = 1
      self.save
    end
    result
  end

  MODES = {(I18n.t 'tournamet_modes.free4all') => -1,
           (I18n.t 'tournamet_modes.pyramidal') => 0}

  PYRAMIDAL_MODES = {
      (I18n.t 'tournamet_modes.not_allowed') => -2,
      (I18n.t 'tournamet_modes.instantwinner') => 0,
      (I18n.t 'tournamet_modes.onewinner') => 1,
      (I18n.t 'tournamet_modes.twowinner') => 2,
      (I18n.t 'tournamet_modes.threewinner') => 3,
      (I18n.t 'tournamet_modes.fourwinner') => 4,
      (I18n.t 'tournamet_modes.fivewinner') => 5
  }

  private

  def start_free4all
    status = true
    errors = []
    selector = RoundSelector.new(self.rounds, self.users.to_a, self.board_size)
    round_matches = selector.select_all_rounds

    round_matches.each_with_index do |round, round_number|
      round.each do |match|
        user_attributes = {}
        match.each do |user|
          user_attributes[user[:id]] = {:user_id => user[:id]}
        end

        match_parameters = {
            :n_players => match.count,
            :round => round_number+1,
            :tournament_id => self.id,
            :user_matches_attributes => user_attributes
        }
        new_match = Match.new_with_child(match_parameters)
        unless new_match[:status]
          status = false
          errors.push(new_match[:errors])
          break
        end
      end

      unless status
        break
      end
    end
    {:status => status, :errors => errors}
  end

  def start_pyramidal

  end
end

