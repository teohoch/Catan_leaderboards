require 'bigdecimal'
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :inscriptions
  has_many :tournaments, through: :inscriptions

  has_many :officed_tournaments, :class_name => 'Tournament', :foreign_key => 'officer_id'

  has_many :user_matches
  has_many :matches, through: :user_matches


  NEWBIE_THRESHOLD = 2
  AVAILABLE_RANKINGS = [:general, :free, :tournament]

  AVAILABLE_RANKINGS.each do |type|
    define_method "position_#{type}" do
      position(type)
    end
  end

  def to_label
    self.name
  end

  def position(type)
    if self.matches_played > NEWBIE_THRESHOLD
      inner_query = User.select("users.id, DENSE_RANK() OVER(ORDER BY users.elo_#{type.to_s} DESC) AS position").where("matches_played > ?", NEWBIE_THRESHOLD).to_sql
      User.from("(#{inner_query}) s").where("id = ?", self.id).pluck('s.position').first
    else
      BigDecimal::INFINITY
    end
  end

end
