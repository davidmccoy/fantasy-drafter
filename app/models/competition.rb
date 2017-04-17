class Competition < ApplicationRecord

  belongs_to :game
  has_many :leagues
  has_many :competition_players
  has_many :players, through: :competition_players

end
