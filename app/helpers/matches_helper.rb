module MatchesHelper
  def victory_position_human(position)
    case position
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
end
