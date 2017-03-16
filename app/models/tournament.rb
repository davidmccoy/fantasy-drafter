class Tournament < ApplicationRecord

  belongs_to :competition
  has_one :admin, foreign_key: "user_id", class_name: "User"
  has_many :users, through: :tournament_users

end
