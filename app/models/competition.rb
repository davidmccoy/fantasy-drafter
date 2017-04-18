class Competition < ApplicationRecord

  belongs_to :game
  belongs_to :season
  has_many :leagues, as: :leagueable
  has_many :competition_players
  has_many :players, through: :competition_players

end
