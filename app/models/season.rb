class Season < ApplicationRecord

  belongs_to :game
  has_many :leagues, as: :leagueable
  has_many :competitions
  has_many :players, -> { distinct }, through: :competitions

  def to_param
    slug
  end

end
