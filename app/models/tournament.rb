class Tournament < ApplicationRecord

  belongs_to :competition
  has_many :tournament_users
  has_many :users, through: :tournament_users
  belongs_to :admin, class_name: "User", foreign_key: "user_id"

end
