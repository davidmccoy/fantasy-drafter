class Competition < ApplicationRecord

  belongs_to :game
  belongs_to :season, optional: true
  has_many :leagues, as: :leagueable
  has_many :competition_players
  has_many :players, through: :competition_players
  has_many :results

end
