class Competition < ApplicationRecord

  belongs_to :game
  has_many :tournaments

end
