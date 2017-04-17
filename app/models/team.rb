class Team < ApplicationRecord

  belongs_to :league_user
  has_many :picks

end
