class Competition < ApplicationRecord
  belongs_to :game
  belongs_to :season, optional: true
  has_many :leagues, as: :leagueable
  has_many :competition_players, dependent: :destroy
  has_many :players, through: :competition_players
  has_many :card_competitions, dependent: :destroy
  has_many :cards, through: :card_competitions
  has_many :character_competitions, dependent: :destroy
  has_many :characters, through: :character_competitions
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

  # uses seeds
  def create_bracket_matches
    groups = character_competitions.pluck(:group).uniq
    num_teams = character_competitions.count
    num_teams_per_group = num_teams / groups.count

    # find number of rounds (assuming a perfect power of two)
    num_rounds = 1
    while (2 ** num_rounds) < num_teams_per_group
      num_rounds += 1
    end

    # iterate through each group
    groups.each do |group|
      char_comps = character_competitions.where(group: group).order(:seed)
      num_teams_in_group = char_comps.count

      # iterate over each round
      num_rounds.times do |rounds_index|
        round_number = rounds_index + 1
        num_matches_in_round = num_teams_in_group / 2 ** round_number

        # create each match
        num_matches_in_round.times do |matches_index|
          match_number = matches_index + 1
          bracket_positioning = {
           1 => 1,
           2 => 8,
           3 => 5,
           4 => 4,
           5 => 3,
           6 => 6,
           7 => 7,
           8 => 2
          }

          # - only assign teams to matches in the first round
          # - otherwise, determine which matches from the previous round will
          #     feed the match
          if round_number == 1
            Match.create(
              competition_id:             id,
              player_a_id:                char_comps.first.character_id,
              player_b_id:                char_comps.last.character_id,
              round:                      round_number,
              group:                      group,
              bracket_position:           bracket_positioning[match_number],
              player_a_previous_match_id: nil,
              player_b_previous_match_id: nil,
              winner_id:                  nil
            )

            # remove teams from the array
            char_comps = char_comps - [char_comps.first] - [char_comps.last]
          else
            top_team_previous_match_bracket_position = (match_number * 2) - 1
            top_team_previous_match = Match.find_by(
              competition_id:   id,
              round:            round_number - 1,
              group:            group,
              bracket_position: top_team_previous_match_bracket_position
            )

            bottom_team_previous_match_bracket_position = (match_number * 2)
            bottom_team_previous_match = Match.find_by(
              competition_id:   id,
              round:            round_number - 1,
              group:            group,
              bracket_position: bottom_team_previous_match_bracket_position
            )

            Match.create(
              competition_id:             id,
              player_a_id:                nil,
              player_b_id:                nil,
              round:                      round_number,
              group:                      group,
              bracket_position:           match_number,
              player_a_previous_match_id: top_team_previous_match.id,
              player_b_previous_match_id: bottom_team_previous_match.id,
              winner_id:                  nil
            )
          end
        end
      end
    end
    # if there is more than one group, create rounds between the winners
    # of those groups.
    # TODO: currently doesn't handle more than two groups.
    if groups.length > 1
      # find last round of each group
      last_rounds = []
      groups.each do |group|
        match = Match.find_by(
          competition_id: id,
          round:          num_rounds,
          group:          group
        )
        last_rounds << match
      end

      # # find number of extra rounds
      # num_extra_rounds = 1
      # while (2 ** num_extra_rounds) < last_rounds.count
      #   num_extra_rounds += 1
      # end

      # num_extra_rounds.times do |extra_rounds_index|
      # end
      top_team_previous_match    = last_rounds.first
      bottom_team_previous_match = last_rounds.second

      Match.create(
        competition_id:             id,
        player_a_id:                nil,
        player_b_id:                nil,
        round:                      num_rounds + 1,
        group:                      'finals',
        bracket_position:           1,
        player_a_previous_match_id: top_team_previous_match.id,
        player_b_previous_match_id: bottom_team_previous_match.id,
        winner_id:                  nil
      )
    end
  end

  # unseeded
  def create_double_elim_bracket_matches
    groups = competition_players.pluck(:group).uniq
    num_teams = competition_players.count
    num_teams_per_group = num_teams / groups.count
    num_winners_rounds = 3
    num_losers_rounds = 4

    # iterate through each group
    groups.each do |group|
      comp_players = competition_players.where(group: group).where.not(seed: nil).order(:seed)
      num_teams_in_group = comp_players.count

      # iterate over each round to create winners' bracket
      num_winners_rounds.times do |rounds_index|
        round_number = rounds_index + 1
        num_matches_in_round = num_teams_in_group / 2 ** round_number

        # create each match
        num_matches_in_round.times do |matches_index|
          match_number = matches_index + 1

          # - only assign teams to matches in the first round
          # - otherwise, determine which matches from the previous round will
          #     feed the match
          if round_number == 1
            Match.create(
              competition_id:             id,
              player_a_id:                comp_players.first.player_id,
              player_b_id:                comp_players.second.player_id,
              player_type:                'Player',
              round:                      round_number,
              group:                      group,
              bracket_section:            'winners',
              bracket_position:           match_number,
              player_a_previous_match_id: nil,
              player_b_previous_match_id: nil,
              winner_id:                  nil
            )

            # remove teams from the array
            comp_players = comp_players - [comp_players.first] - [comp_players.second]
          else
            # create winners' bracket matches
            top_team_previous_match_bracket_position = (match_number * 2) - 1
            top_team_previous_match = Match.find_by(
              competition_id:   id,
              round:            round_number - 1,
              group:            group,
              bracket_section:  'winners',
              bracket_position: top_team_previous_match_bracket_position
            )

            bottom_team_previous_match_bracket_position = (match_number * 2)
            bottom_team_previous_match = Match.find_by(
              competition_id:   id,
              round:            round_number - 1,
              group:            group,
              bracket_section:  'winners',
              bracket_position: bottom_team_previous_match_bracket_position
            )

            Match.create(
              competition_id:             id,
              player_a_id:                nil,
              player_b_id:                nil,
              player_type:                'Player',
              round:                      round_number,
              group:                      group,
              bracket_section:            'winners',
              bracket_position:           match_number,
              player_a_previous_match_id: top_team_previous_match.id,
              player_b_previous_match_id: bottom_team_previous_match.id,
              winner_id:                  nil
            )
          end
        end
      end

      # iterate over each round to create losers' bracket
      num_losers_rounds.times do |rounds_index|
        # losers' bracket starts in round 2
        round_number = rounds_index + 2
        num_matches_in_round = {
          2 => 4,
          3 => 4,
          4 => 2,
          5 => 2
        }
        # create each match
        num_matches_in_round[round_number].times do |matches_index|
          match_number = matches_index + 1
          # first round of losers' bracket
          if round_number == 2
            # fill initial losers' bracket matches from all of the losers
            # from round 1
            top_team_previous_match_bracket_position = (match_number * 2) - 1
            top_team_previous_match = Match.find_by(
              competition_id:   id,
              round:            round_number - 1,
              group:            group,
              bracket_section:  'winners',
              bracket_position: top_team_previous_match_bracket_position
            )

            bottom_team_previous_match_bracket_position = (match_number * 2)
            bottom_team_previous_match = Match.find_by(
              competition_id:   id,
              round:            round_number - 1,
              group:            group,
              bracket_section:  'winners',
              bracket_position: bottom_team_previous_match_bracket_position
            )

            Match.create(
              competition_id:             id,
              player_a_id:                nil,
              player_b_id:                nil,
              player_type:                'Player',
              round:                      round_number,
              group:                      group,
              bracket_section:            'losers',
              bracket_position:           match_number,
              player_a_previous_match_id: top_team_previous_match.id,
              player_b_previous_match_id: bottom_team_previous_match.id,
              winner_id:                  nil
            )
          # fill top of each round 3 match with winner's bracket losers from
          # round 2 and the bottom of each match with the losers' bracket
          # winner from round 2
          elsif round_number == 3
            winners_bracket_match_position = num_matches_in_round[round_number] - matches_index
            top_team_previous_match = Match.find_by(
              competition_id:   id,
              round:            round_number - 1,
              group:            group,
              bracket_section:  'winners',
              bracket_position: winners_bracket_match_position
            )

            bottom_team_previous_match_bracket_position = match_number
            bottom_team_previous_match = Match.find_by(
              competition_id:   id,
              round:            round_number - 1,
              group:            group,
              bracket_section:  'losers',
              bracket_position: bottom_team_previous_match_bracket_position
            )

            Match.create(
              competition_id:             id,
              player_a_id:                nil,
              player_b_id:                nil,
              player_type:                'Player',
              round:                      round_number,
              group:                      group,
              bracket_section:            'losers',
              bracket_position:           match_number,
              player_a_previous_match_id: top_team_previous_match.id,
              player_b_previous_match_id: bottom_team_previous_match.id,
              winner_id:                  nil
            )

          # fill both matches with the losers' bracket winners from round 3
          elsif round_number == 4
            top_team_previous_match_bracket_position = (match_number * 2) - 1
            top_team_previous_match = Match.find_by(
              competition_id:   id,
              round:            round_number - 1,
              group:            group,
              bracket_section:  'losers',
              bracket_position: top_team_previous_match_bracket_position
            )

            bottom_team_previous_match_bracket_position = (match_number * 2)
            bottom_team_previous_match = Match.find_by(
              competition_id:   id,
              round:            round_number - 1,
              group:            group,
              bracket_section:  'losers',
              bracket_position: bottom_team_previous_match_bracket_position
            )

            Match.create(
              competition_id:             id,
              player_a_id:                nil,
              player_b_id:                nil,
              player_type:                'Player',
              round:                      round_number,
              group:                      group,
              bracket_section:            'losers',
              bracket_position:           match_number,
              player_a_previous_match_id: top_team_previous_match.id,
              player_b_previous_match_id: bottom_team_previous_match.id,
              winner_id:                  nil
            )
          # fill top of each round 5 match with winner's bracket losers from
          # round 3 and the bottom of each match with the losers' bracket
          # winner from round 4
          elsif round_number == 5
            winners_bracket_match_position = num_matches_in_round[round_number] - matches_index
            top_team_previous_match = Match.find_by(
              competition_id:   id,
              round:            round_number - 2,
              group:            group,
              bracket_section:  'winners',
              bracket_position: winners_bracket_match_position
            )

            bottom_team_previous_match_bracket_position = match_number
            bottom_team_previous_match = Match.find_by(
              competition_id:   id,
              round:            round_number - 1,
              group:            group,
              bracket_section:  'losers',
              bracket_position: bottom_team_previous_match_bracket_position
            )

            Match.create(
              competition_id:             id,
              player_a_id:                nil,
              player_b_id:                nil,
              player_type:                'Player',
              round:                      round_number,
              group:                      group,
              bracket_section:            'losers',
              bracket_position:           match_number,
              player_a_previous_match_id: top_team_previous_match.id,
              player_b_previous_match_id: bottom_team_previous_match.id,
              winner_id:                  nil
            )
          end
        end
      end
    end
  end
end
