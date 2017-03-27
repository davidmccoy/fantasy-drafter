class Competition < ApplicationRecord

  belongs_to :game
  has_many :tournaments
  has_many :competition_players
  has_many :players, through: :competition_players

end
