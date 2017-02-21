class UserMatch < ApplicationRecord
  belongs_to :user
  belongs_to :match, counter_cache: :n_players

  POSITION = {
      (I18n.t "first") => 1,
      (I18n.t "second") => 2,
      (I18n.t "third") => 3,
      (I18n.t "fourth") => 4,
      (I18n.t "fith") => 5,
      (I18n.t "sixth") => 6
  }

  def victory_position_human
    case self.victory_position
      when 1
        I18n.t "first"
      when 2
        I18n.t "second"
      when 3
        I18n.t "third"
      when 4
        I18n.t "fourth"
      when 5
        I18n.t "fith"
      when 6
        I18n.t "sixth"
    end
  end

  def validated_human
    if self.validated
      I18n.t "positive"
    else
      I18n.t "negatory"
    end
  end
end
