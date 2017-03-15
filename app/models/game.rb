class Game < ApplicationRecord

  has_many :competitions

  enum type: [:Unknown, :TCG]

end
