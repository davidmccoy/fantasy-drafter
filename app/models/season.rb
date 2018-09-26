class Season < ApplicationRecord

  belongs_to :game
  has_many :leagues, as: :leagueable
  has_many :competitions

end
