class Competition < ApplicationRecord
  belongs_to :game
  belongs_to :season, optional: true
  has_many :leagues, as: :leagueable
  has_many :competition_players, dependent: :destroy
  has_many :players, through: :competition_players
  has_many :card_competitions
  has_many :cards, through: :card_competitions
  has_many :results
  has_many :matches

  before_save { self.slug = slug.downcase if slug }

  def to_param
    slug
  end

  def get_matches
    response = HTTParty.get('https://4mwii0iu4c.execute-api.us-east-1.amazonaws.com/beta/leagues/VSL/seasons/9.json')
    data = JSON.parse(response.body)

    data['schedule']['scheduleEvents'].first['matches'].each do |match|
      player_a = Player.find_by_name(match['playerAName'])
      player_b = Player.find_by_name(match['playerBName'])

      if player_a && player_b
        player_a.update(arcanis_id: match['playerAId'])
        player_b.update(arcanis_id: match['playerBId'])
        Match.where(
          competition_id: id,
          player_a_id: player_a.id,
          player_b_id: player_b.id,
          arcanis_id: match['matchId']
        ).first_or_create
      else
        p "either #{match['playerAName']} or #{match['playerBName']} wasn't found"
      end
    end
  end
end
