class Card < ApplicationRecord
  has_many :card_competitions
  has_many :competitions, through: :card_competitions
  has_many :picks, as: :pickable
  has_many :results, as: :resultable

  validates :name, uniqueness: { case_sensitive: false }

  def xrank leagueable
    if leagueable.class.to_s == "Season"
      card_competitions.find_by(competition_id: leagueable.competitions.first).xrank
    else
      card_competitions.find_by(competition_id: leagueable).xrank
    end
  end

  def percent_of_decks leagueable
    if leagueable.class.to_s == "Season"
      card_competitions.find_by(competition_id: leagueable.competitions.first).percent_of_decks
    else
      card_competitions.find_by(competition_id: leagueable).percent_of_decks
    end
  end

  def number_of_copies leagueable
    if leagueable.class.to_s == "Season"
      card_competitions.find_by(competition_id: leagueable.competitions.first).number_of_copies
    else
      card_competitions.find_by(competition_id: leagueable).number_of_copies
    end
  end

  def result competition
    self.results.find_by(competition_id: competition.id)
  end

  def get_scryfall_info
    p "finding #{name}"

    if name.include? ','
      url_safe_card_name = name.gsub(/\,/,"").downcase.split(' ').join('+')
    else
      url_safe_card_name = name.downcase.split(' ').join('+')
    end

    url = "https://api.scryfall.com/cards/named?exact=#{url_safe_card_name}"
    p url

    response = HTTParty.get(url)
    if response.code == 200
      if response['layout'] == 'transform'
        image = response['card_faces'].first['image_uris']['normal']
      else
        image = response['image_uris']['normal']
      end
      self.update(
        scryfall_id: response['id'],
        oracle_id: response['oracle_id'],
        image_uri: image,
        mana_cost: response['mana_cost'],
        cmc: response['cmc'],
        type_line: response['type_line'],
        oracle_text: response['oracle_text'],
        power: response['power'],
        toughness: response['toughness'],
        loyalty: response['loyalty'],
        colors: response['colors'],
        legalities: response['legalities'],
        rarity: response['rarity'],
        flavor_text: response['flavor_text'],
        artist: response['artist'],
        frame: response['frame']
      )
    end
    sleep(1.0/4.0)
  end
end
