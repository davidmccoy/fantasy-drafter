json.players @available_players do |card|
  json.star_link game_competition_league_draft_stars_path(
                @draft.league.leagueable.game,
                @draft.league.leagueable,
                @draft.league,
                @draft,
                starrable_type: 'Card',
                starrable_id: card.id,
                protocol: "https"
              )
  json.player_id card.id
  json.pickable_type 'Card'
  json.points card.points
  json.percent_of_decks card.percent_of_decks
  josn.number_of_copies card.number_of_copies
  json.xrank card.xrank
  json.name card.name
  json.pick_link "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/picks/pick-number?pickable_id=#{card.id}" if current_user == @draft.league.admin || (@current_pick && current_user == @current_pick.user) || (@draft.league.draft_type != 'snake')
end
