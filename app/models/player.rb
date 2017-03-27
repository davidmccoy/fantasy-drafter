class Player < ApplicationRecord

  has_many :picks
  has_many :competition_players
  has_many :competitions, through: :competition_players

end
