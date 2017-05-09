class Result < ApplicationRecord

  belongs_to :player
  belongs_to :competition
  belongs_to :game
  
end
