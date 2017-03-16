class Game < ApplicationRecord

  has_many :competitions

  enum category: [:Unknown, :TCG]

end
