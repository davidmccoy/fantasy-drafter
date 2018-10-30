class Card < ApplicationRecord
  has_many :card_competitions
  has_many :competitions, through: :card_competitions

  def xrank competition
    card_competitions.find_by(competition_id: competition).xrank
  end 

  def percent_of_decks competition
    card_competitions.find_by(competition_id: competition).percent_of_decks
  end 

  def number_of_copies competition
    card_competitions.find_by(competition_id: competition).number_of_copies
  end 
end
