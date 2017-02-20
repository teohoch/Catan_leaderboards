class UserMatch < ApplicationRecord
  belongs_to :user, counter_cache: :matches_played
  belongs_to :match, counter_cache: :n_players

  def validated_human
    if self.validated
      I18n.t "positive"
    else
      I18n.t "negatory"
    end
  end
end
