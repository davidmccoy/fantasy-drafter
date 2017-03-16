class User < ApplicationRecord

  has_many :tournaments, through: :tournament_users
  has_many :tournament_admins, class_name: "Tournament", foreign_key: "user_id"

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable

  protected

  def confirmation_required?
   false
  end

end
