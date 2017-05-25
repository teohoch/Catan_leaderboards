class MatchDecorator < ApplicationDecorator
  delegate_all
  def attributes
    ['n_players','expected_number_players','round','date','location','validated'].map{|key| [key, self.send(key)]}
  end

  def pretty_show
    super(title: h.t('match.show.table_title'))
  end

  def date
    model.date.nil? ? (h.t 'not_set') : super
  end

  def location
    model.location.nil? ? (h.t 'not_set') : super
  end
end