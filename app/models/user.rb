class User < ApplicationRecord

  has_many :league_users
  has_many :leagues, through: :league_users
  has_many :league_admins, class_name: "League", foreign_key: "user_id"
  has_many :picks
  has_many :drafts, through: :leagues 

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable

  protected

  def confirmation_required?
   false
  end

end
