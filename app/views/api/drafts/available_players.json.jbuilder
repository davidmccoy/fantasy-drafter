json.players @available_players do |player|
  json.star_link game_competition_league_draft_stars_path(
                @draft.league.leagueable.game,
                @draft.league.leagueable,
                @draft.league,
                @draft,
                player_id: player.id,
                protocol: "https"
              )
  json.player_id player.id
  json.points player.points
  json.elo player.elo
  json.power_ranking player.power_ranking
  json.name player.name
  json.pick_link "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/picks/pick-number?player_id=#{player.id}" if current_user == @draft.league.admin || (@current_pick && current_user == @current_pick.user) || (@draft.league.draft_type != 'snake')
end
