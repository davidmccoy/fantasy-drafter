module Standings
  class Season
    class Tiebreakers
      class << self
        # MPL tiebreakers
        # Tiebreaker 1: Best individual Swiss match point performance at a 2020 Players Tour Finals
        # Tiebreaker 2: Best individual Swiss match win performance at a 2020 Mythic Invitational.
        # Tiebreaker 3: Best final standing at a 2020 Players Tour.

        # MPL tiebreaker 1
        # Tiebreaker 1: Best individual Swiss match point performance at a 2020 Players Tour Finals
        def best_individual_swiss_match_points_in_players_tour_finals(season, competitions, player)
          # competitions do not have types/categories
          competition_ids = competitions.select { |c| c.name.include? 'Finals' }
          # TODO: we don't have match points yet
          results = player.results.where(competition_id: competition_ids).order(points: :desc)
          results.first&.points
        end

        # MPL tiebreaker 2
        # Tiebreaker 2: Best individual Swiss match win performance at a 2020 Mythic Invitational.
        def best_individual_swiss_match_points_in_mythic_invitational(season, competitions, player)
          competition_ids = competitions.select { |c| c.name.include? 'Mythic Invitational' }
          # TODO: we don't have match points yet
          results = player.results.where(competition_id: competition_ids).order(points: :desc)
          results.first&.points
        end

        # MPL tiebreaker 3
        # Tiebreaker 3: Best final standing at a 2020 Players Tour.
        def best_final_standing_at_players_tour(season, competitions, player)
          competition_ids = competitions.select { |c| c.name.include? 'Players Tour Series' }
          results = player.results.where(competition_id: competition_ids).order(place: :asc)
          results.first&.place
        end

        # Rivals Mythic Point tiebreakers
        # Tiebreaker 1: Greatest number of 2020 season Mythic Invitational Final Day finishes.
        # Tiebreaker 2: Greatest number of Swiss match wins at 2020 Mythic Invitationals.
        # Tiebreaker 3: Best individual Swiss match win record at a single 2020 Mythic Invitational.

        # Rivals Mythic Point Tiebreaker 1
        # Greatest number of 2020 season Mythic Invitational Final Day finishes.
        def number_of_mythic_invitational_final_day_finishes(season, competitions, player)
          # competitions do not have types/categories
          competition_ids = competitions.select { |c| c.name.include? 'Mythic Invitational' }
          # TODO: we don't have match points yet
          results = player.results.where(competition_id: competition_ids).order(place: :asc)

          results.select { |r| r.place && r.place <= 8 }.count
        end

        # Rivals Mythic Point Tiebreaker 2
        # Greatest number of Swiss match wins at 2020 Mythic Invitationals.
        def number_of_swiss_match_wins_in_mythic_invitationals(season, competitions, player)
          # competitions do not have types/categories
          competition_ids = competitions.select { |c| c.name.include? 'Mythic Invitational' }
          # TODO: we don't have match points yet
          results = player.results.where(competition_id: competition_ids).order(points: :desc)
          results.sum(:points)
        end

        # Rivals Mythic Point Tiebreaker 3
        # Best individual Swiss match win record at a single 2020 Mythic Invitational.
        def best_individual_swiss_match_win_record_in_mythic_invitational(season, competitions, player)
          # competitions do not have types/categories
          competition_ids = competitions.select { |c| c.name.include? 'Mythic Invitational' }
          # TODO: we don't have match points yet
          results = player.results.where(competition_id: competition_ids).order(points: :desc)
          !results.empty? ? results.first.points / 3 : 0
        end

        # Rivals Player Point tiebreakers
        # Tiebreaker 1: Greatest number of 2020 season Players Tour Finals Final Days.
        # Tiebreaker 2: Greatest number of 2020 season Players Tour Top 8s.
        # Tiebreaker 3: Best individual Swiss match point performance at a 2020 Players Tour Finals.
        # Tiebreaker 4: Best final standing at a 2020 Players Tour.

        # Rivals Player Point Tiebreaker 1
        # Greatest number of 2020 season Players Tour Finals Final Days.
        def number_of_players_tour_finals_final_day_finishes(season, competitions, player)
          # competitions do not have types/categories
          competition_ids = competitions.select { |c| c.name.include? 'Players Tour Finals' }
          # TODO: we don't have match points yet
          results = player.results.where(competition_id: competition_ids).order(place: :asc)

          results.select { |r| r.place && r.place <= 8 }.count
        end

        # Rivals Player Point Tiebreaker 2
        # Greatest number of 2020 season Players Tour Top 8s.
        def number_of_players_tour_top_8s(season, competitions, player)
          # competitions do not have types/categories
          competition_ids = competitions.select { |c| c.name.include? 'Players Tour Series' }
          # TODO: we don't have match points yet
          results = player.results.where(competition_id: competition_ids).order(place: :asc)

          results.select { |r| r.place && r.place <= 8 }.count
        end

        # NOTE: same as for the MPL
        # Rivals Player Point Tiebreaker 3
        # Best individual Swiss match point performance at a 2020 Players Tour Finals.
        # def best_individual_swiss_match_points_in_players_tour_finals(season, competitions, player)
        # end

        # NOTE: same as for the MPL
        # Rivals Player Point Tiebreaker 4
        # Best final standing at a 2020 Players Tour.
        # def best_final_standing_at_players_tour(season, competitions, player)
        # end
      end
    end
  end
end