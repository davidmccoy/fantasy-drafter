class League < ApplicationRecord

  belongs_to :competition
  has_many :league_users
  has_many :users, through: :league_users
  belongs_to :admin, class_name: "User", foreign_key: "user_id"
  has_one :draft
  has_many :teams, through: :league_users

end
