class Character < ApplicationRecord
  has_many :character_competitions
  has_many :competitions, through: :character_competitions
  has_many :picks, as: :pickable
  has_many :results, as: :resultable

  def seed(competition)
    character_competitions.find_by(competition_id: competition.id).seed
  end
end
