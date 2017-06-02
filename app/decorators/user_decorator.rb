class UserDecorator < ApplicationDecorator
  delegate_all

  def position_free
    if model.position_free > 0
      model.position_free
    else
      I18n.t 'not_asigned'
    end
  end

  def position_general
    if model.position_general > 0
      model.position_general
    else
      I18n.t 'not_asigned'
    end
  end

  def position_tournament
    if model.position_tournament > 0
      model.position_tournament
    else
      I18n.t 'not_asigned'
    end
  end

end