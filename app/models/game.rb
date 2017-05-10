class Game < ApplicationRecord

  has_many :competitions
  has_many :results

  enum category: [:Unknown, :TCG]

end
