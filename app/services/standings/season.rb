module Standings
  class Season
    class << self
      def generate_points(season, player)
        competition_ids = season.competitions.pluck(:id)
        results = ::Result.where(
          resultable_id: player.id,
          resultable_type: 'Player',
          competition_id: competition_ids
        )

        points = {
          mythic_points: 0,
          player_points: 0,
          winnings: 0,
        }

        results.each do |result|
          result_type = result.rank_points_type.parameterize.underscore.to_sym
          result_points = result.rank_points
          current_points = points[result_type]
          new_points = current_points + result_points

          points[result_type] = new_points

          new_winnings = result.winnings || 0
          points[:winnings] += new_winnings
        end

        standing = ::Standing.where(
          season_id: season.id,
          player_id: player.id,
        ).first_or_initialize

        standing.update(
          mythic_points: points[:mythic_points],
          player_points: points[:player_points],
          total_points: points[:mythic_points] + points[:player_points],
          winnings: points[:winnings],
        )
      end

      def generate_ranks(season)
        leagues = ['MPL', 'Rivals']
        leagues.each do |league|
          player_ids = season.players.where(league: league).pluck(:id)
          set_season_long_tiebreakers(season, player_ids, league)
          set_season_long_ranks(season, player_ids)
          send("set_qualifications_for_#{league.downcase}", season, player_ids)
        end
      end

      def set_season_long_tiebreakers(season, player_ids, league)
        competitions = season.competitions
        standings = season.standings
                          .includes(:player)
                          .where(player_id: player_ids)

        standings.each do |standing|
          tiebreakers = standing.tiebreakers
          find_tiebreaker = Standings::Season::Tiebreakers::Mpl

          if league == 'MPL'
            standing.tiebreakers = {
              mpl: {
                first_tiebreaker: find_tiebreaker.first(season, competitions, standing.player),
                second_tiebreaker: find_tiebreaker.second(season, competitions, standing.player),
                third_tiebreaker: find_tiebreaker.third(season, competitions, standing.player),
              },
              rivals_mythic_points: {
                first_tiebreaker: nil,
                second_tiebreaker: nil,
                third_tiebreaker: nil,
              },
              rivals_player_points: {
                first_tiebreaker: nil,
                second_tiebreaker: nil,
                third_tiebreaker: nil,
                fourth_tiebreaker: nil,
              }
            }
          elsif league == 'Rivals'
            find_mp_tiebreaker = Standings::Season::Tiebreakers::Rivals::MythicPoints
            find_pp_tiebreaker = Standings::Season::Tiebreakers::Rivals::PlayerPoints

            standing.tiebreakers = {
              mpl: {
                first_tiebreaker: nil,
                second_tiebreaker: nil,
                third_tiebreaker: nil,
              },
              rivals_mythic_points: {
                first_tiebreaker: find_mp_tiebreaker.first(season, competitions, standing.player),
                second_tiebreaker: find_mp_tiebreaker.second(season, competitions, standing.player),
                third_tiebreaker: find_mp_tiebreaker.third(season, competitions, standing.player),
              },
              rivals_player_points: {
                first_tiebreaker: find_pp_tiebreaker.first(season, competitions, standing.player),
                second_tiebreaker: find_pp_tiebreaker.second(season, competitions, standing.player),
                third_tiebreaker: find_pp_tiebreaker.third(season, competitions, standing.player),
                fourth_tiebreaker: find_pp_tiebreaker.fourth(season, competitions, standing.player),
              },
            }
          end

          standing.save
        end
      end

      # TODO: this is pretty useless outside of the MPL
      def set_season_long_ranks(season, player_ids)
        standings = season.standings
                          .includes(:player)
                          .where(player_id: player_ids)
                          .order('total_points desc')
                          .order('players.name asc')
        standings.each_with_index do |standing, index|
          standing.update(place: index + 1)
        end
      end

      # TODO: needs tiebreakers
      def set_qualifications_for_mpl(season, player_ids)
        # Paulo qualifies for 2020-21 MPL via WCXXVI
        pvddr = Player.find_by_name('Paulo Vitor Damo da Rosa')
        pv_standing = season.standings.find_by(player_id: pvddr.id)
        pv_standing.update(
          qualifies_for: '2020-21 Magic Pro League',
          qualifies_via: 'Won World Championship XXVI',
        )

        # remove Paulo from the calculations
        player_ids = player_ids - [pvddr.id]

        # use the remaining standings to calculate qualifications
        standings = season.standings.where(player_id: player_ids).order('place asc')
        standings.each_with_index do |standing, index|
          place = index + 1

          if place <= 16
            standing.update(
              qualifies_for: '2020-21 Magic Pro League',
              qualifies_via: 'Top 16 of the 2020 MPL',
            )
          elsif place <= 19
            standing.update(
              qualifies_for: '2020 MPL Gauntlet',
              qualifies_via: 'Place 17-19 of the 2020 MPL',
            )
          else
            standing.update(
              qualifies_for: '2020-21 Magic Rivals League',
              qualifies_via: 'Place 20-23 of the 2020 MPL',
            )
          end
        end
      end

      # TODO: needs tiebreakers
      def set_qualifications_for_rivals(season, player_ids)
        # top Mythic and Player Point earners qualify for the 2020-21 MPL
        first_place_mythic = season.standings
                                   .where(player_id: player_ids)
                                   .order('mythic_points desc, total_points desc')
                                   .first
        first_place_mythic.update(
          qualifies_for: '2020-21 Magic Pro League',
          qualifies_via: 'Top Rival by Mythic Points',
        )

        # remove the first place mythic from the pool of players
        player_ids = player_ids - [first_place_mythic.player_id]

        first_place_player = season.standings
                                   .where(player_id: player_ids)
                                   .order('player_points desc, total_points desc')
                                   .first
        first_place_player.update(
          qualifies_for: '2020-21 Magic Pro League',
          qualifies_via: 'Top Rival by Player Points',
        )

        # remove first place in player points from the pool of players
        player_ids = player_ids - [first_place_player.player_id]

        mythic_standings = season.standings
                                 .where(player_id: player_ids)
                                 .order('mythic_points desc, player_points')
                                 .first(6)
        mythic_standings.each do |standing|
          standing.update(
            qualifies_for: '2020 MPL Gauntlet',
            qualifies_via: '2-7 Rival by Mythic Points',
          )
        end

        # remove the qualified players from the pool of players
        player_ids = player_ids - mythic_standings.pluck(:player_id)

        player_standings = season.standings
                                 .where(player_id: player_ids)
                                 .order('player_points desc, total_points desc')
                                 .first(6)
        player_standings.each do |standing|
          standing.update(
            qualifies_for: '2020 MPL Gauntlet',
            qualifies_via: '2-7 Rival by Player Points',
          )
        end
      end
    end
  end
end