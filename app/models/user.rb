class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :tournaments
  has_many :inscriptions
  has_many :user_matches
  has_many :matches, through: :user_matches


  def to_label
    return self.name
  end
end
