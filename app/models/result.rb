class Result < ApplicationRecord

  belongs_to :resultable, polymorphic: true
  belongs_to :competition
  belongs_to :game
  
end
