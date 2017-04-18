class League < ApplicationRecord

  belongs_to :leagueable, polymorphic: true
  has_many :league_users, dependent: :destroy
  has_many :users, through: :league_users
  belongs_to :admin, class_name: "User", foreign_key: "user_id"
  has_one :draft, dependent: :destroy
  has_many :teams, through: :league_users

end
