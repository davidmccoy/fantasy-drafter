class Season < ApplicationRecord
  belongs_to :game
  has_many :leagues, as: :leagueable
  has_many :competitions
  has_many :players, -> { distinct }, through: :competitions
  has_many :cards, -> { distinct }, through: :competitions

  def to_param
    slug
  end

  def score_as_of_round
    competitions.sum(&:score_as_of_round)
  end
end
