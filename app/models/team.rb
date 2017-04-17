class Team < ApplicationRecord

  belongs_to :league_user
  has_one :user, through: :league_user
  has_many :picks


end
