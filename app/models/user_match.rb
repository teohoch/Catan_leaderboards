class UserMatch < ApplicationRecord
  belongs_to :user
  belongs_to :match, counter_cache: :n_players

  POSITION = {
      (I18n.t 'first_place') => 1,
      (I18n.t 'second_place') => 2,
      (I18n.t 'third_place') => 3,
      (I18n.t 'fourth_place') => 4,
      (I18n.t 'fith_place') => 5,
      (I18n.t 'sixth_place') => 6
  }

end
