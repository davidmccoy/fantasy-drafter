module Standings
  class Season
    class Tiebreakers
      class Mpl
        class << self
          def first(season, competitions, player)
            Standings::Season::Tiebreakers.best_individual_swiss_match_points_in_players_tour_finals(season, competitions, player)
          end

          def second(season, competitions, player)
            Standings::Season::Tiebreakers.best_individual_swiss_match_points_in_mythic_invitational(season, competitions, player)
          end

          def third(season, competitions, player)
            Standings::Season::Tiebreakers.best_final_standing_at_players_tour(season, competitions, player)
          end
        end
      end
    end
  end
end