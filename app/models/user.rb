class User < ApplicationRecord

  has_many :league_users
  has_many :leagues, through: :league_users
  has_many :league_admins, class_name: "League", foreign_key: "user_id"
  has_many :drafts, through: :leagues
  has_many :teams, through: :league_users
  has_many :picks, through: :teams

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable


  def team(league)
    Team.find_by(user_id: self.id, league_id: league.id)
  end

  protected

  def confirmation_required?
   false
  end

end
