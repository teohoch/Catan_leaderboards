class Tournament < ApplicationRecord
  belongs_to :user
  has_many :inscriptions
  has_many :users, through: :inscriptions
  has_many :matches
  attr_accessor :general_mode

  validates_presence_of :name, :number_players, :prize, :entrance_fee, :user_id, :date, :rounds, :mode
  validates :board_size, inclusion: {in: [4,6]}
  validates :number_players, inclusion: {in: 3..16 }
  validates :mode, inclusion: { in: -1..5}


  def general_mode_human
    if self.mode == 0
      I18n.t "tournamet_modes.free4all"
    else
      I18n.t "tournamet_modes.pyramidal"
    end
  end


  MODES = {(I18n.t "tournamet_modes.free4all")=> 0,
           (I18n.t "tournamet_modes.pyramidal") => 1}

  PYRAMIDAL_MODES = {
      (I18n.t "tournamet_modes.not_allowed") => -2,
      (I18n.t "tournamet_modes.instantwinner") => -1,
      (I18n.t "tournamet_modes.onewinner") => 1,
      (I18n.t "tournamet_modes.twowinner") => 2,
      (I18n.t "tournamet_modes.threewinner") => 3,
      (I18n.t "tournamet_modes.fourwinner") => 4,
      (I18n.t "tournamet_modes.fivewinner") => 5
  }

  def status_human
    case self.status
      when 0
        I18n.t "register_phase"
      when 1
        I18n.t "ongoing"
      when 2
        I18n.t "finalized"
    end
  end

  def mode_human
    case self.mode
      when -1
        I18n.t "tournamet_modes.instantwinner"
      when 0
        I18n.t "tournamet_modes.free4all"
      when 1
        I18n.t "tournamet_modes.onewinner"
      when 2
        I18n.t "tournamet_modes.twowinner"
      when 3
        I18n.t "tournamet_modes.threewinner"
      when 4
        I18n.t "tournamet_modes.fourwinner"
      when 5
        I18n.t "tournamet_modes.fivewinner"
    end
  end
end
