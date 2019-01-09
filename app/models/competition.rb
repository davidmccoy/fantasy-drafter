class Competition < ApplicationRecord
  belongs_to :game
  belongs_to :season, optional: true
  has_many :leagues, as: :leagueable
  has_many :competition_players, dependent: :destroy
  has_many :players, through: :competition_players
  has_many :card_competitions
  has_many :cards, through: :card_competitions
  has_many :results

  before_save { self.slug = slug.downcase if slug }

  def to_param
    slug
  end
end
