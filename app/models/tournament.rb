class Tournament < ApplicationRecord
  belongs_to :user

  def status_human
    case self.status
      when 0
        t "register_phase"
      when 1
        t "ongoing"
      when 2
        t "finalized"
    end
  end
end
