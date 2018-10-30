class Card < ApplicationRecord
  has_many :card_competitions
  has_many :competitions, through: :card_competitions
  has_many :picks, as: :pickable
  has_many :results, as: :resultable

  validates :name, uniqueness: { case_sensitive: false }

  def xrank competition
    card_competitions.find_by(competition_id: competition).xrank
  end 

  def percent_of_decks competition
    card_competitions.find_by(competition_id: competition).percent_of_decks
  end 

  def number_of_copies competition
    card_competitions.find_by(competition_id: competition).number_of_copies
  end 

  def result competition
    self.results.find_by(competition_id: competition.id)
  end
end
