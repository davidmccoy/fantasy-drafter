json.players @available_players do |player|
  json.star_link game_competition_league_draft_pick_path(
                @draft.league.leagueable.game,
                @draft.league.leagueable,
                @draft.league,
                @draft,
                @current_pick,
                player_id: player.id,
                protocol: "https"
              ) if current_user == @draft.league.admin || current_user == @current_pick.user
  json.player_id player.id
  json.points_per_result player.points_per_result
  json.results player.results.count
  json.name player.name
  json.pick_link game_competition_league_draft_pick_path(
                @draft.league.leagueable.game,
                @draft.league.leagueable,
                @draft.league,
                @draft,
                @current_pick,
                player_id: player.id,
                protocol: "https"
              ) if current_user == @draft.league.admin || current_user == @current_pick.user
end
