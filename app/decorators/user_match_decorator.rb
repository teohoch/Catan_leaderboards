class UserMatchDecorator < ApplicationDecorator
  delegate_all
  def initialize(*args)
    super(*args)
    @user = model.user.decorate
  end

  def name
    @user.name
  end

  def position_general
    @user.position_general
  end

  def position_tournament
    @user.position_tournament
  end

  def position_free
    @user.position_free
  end

  def vp
    if model.match.validated
      model.vp
    else
      h.t ('not_set')
    end
  end

  def victory_position
    if model.match.validated
      case self.victory_position
        when 1
          I18n.t 'first_place'
        when 2
          I18n.t 'second_place'
        when 3
          I18n.t 'third_place'
        when 4
          I18n.t 'fourth_place'
        when 5
          I18n.t 'fith_place'
        when 6
          I18n.t 'sixth_place'
        else
          I18n.t 'invalid_place'
      end
    else
      h.t ('not_set')
    end
  end

  def matches_played
    @user.matches_played
  end
end