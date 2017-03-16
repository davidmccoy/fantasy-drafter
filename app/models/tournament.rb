class Tournament < ApplicationRecord

  belongs_to :competition
  belongs_to :admin, class_name: "User", foreign_key: "user_id"
  has_many :users, through: :tournament_users

end
