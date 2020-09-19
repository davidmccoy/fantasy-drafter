module Standings
  class Season
    class Tiebreakers
      class Rivals
        class MythicPoints
          class << self
            def first(season, competitions, player)
              Standings::Season::Tiebreakers.number_of_mythic_invitational_final_day_finishes(season, competitions, player)
            end

            def second(season, competitions, player)
              Standings::Season::Tiebreakers.number_of_swiss_match_wins_in_mythic_invitationals(season, competitions, player)
            end

            def third(season, competitions, player)
              Standings::Season::Tiebreakers.best_individual_swiss_match_win_record_in_mythic_invitational(season, competitions, player)
            end
          end
        end

        class PlayerPoints
          class << self
            def first(season, competitions, player)
              Standings::Season::Tiebreakers.number_of_players_tour_finals_final_day_finishes(season, competitions, player)
            end

            def second(season, competitions, player)
              Standings::Season::Tiebreakers.number_of_players_tour_top_8s(season, competitions, player)
            end

            def third(season, competitions, player)
              Standings::Season::Tiebreakers.best_individual_swiss_match_points_in_players_tour_finals(season, competitions, player)
            end

            def fourth(season, competitions, player)
              Standings::Season::Tiebreakers.best_final_standing_at_players_tour(season, competitions, player)
            end
          end
        end
      end
    end
  end
end