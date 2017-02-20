class Match < ApplicationRecord
  has_many :user_matches, dependent: :destroy
  has_many :users, through: :user_matches
  accepts_nested_attributes_for :user_matches
  validates_presence_of :date, :location

  def validated_human
    if self.validated
      I18n.t "positive"
    else
      I18n.t "negatory"
    end
  end

  def validated_count
    self.user_matches.where(:validated => true).count()
  end


end
