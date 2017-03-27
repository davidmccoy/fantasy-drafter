class Draft < ApplicationRecord

  belongs_to :tournament
  has_many :picks

end
