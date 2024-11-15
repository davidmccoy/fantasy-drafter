json.players @available_players do |pickable|
  if pickable.class.name == 'Match'
    json.id                  pickable.id
    json.player_a_id         pickable.player_a_id
    json.player_a_name       Player.find_by_id(pickable.player_a_id)&.name
    json.player_b_id         pickable.player_b_id
    json.player_b_name       Player.find_by_id(pickable.player_b_id)&.name
    json.winner_id           pickable.winner_id
  else
    json.star_link        game_competition_league_draft_stars_path(
                            @draft.league.leagueable.game,
                            @draft.league.leagueable,
                            @draft.league,
                            @draft,
                            starrable_type: pickable.class.name,
                            starrable_id: pickable.id,
                            protocol: "https"
                          )
    json.player_id         pickable.id
    json.pickable_type     pickable.class.name
    json.points            pickable.class.name == 'Player' ? pickable.points : nil
    json.elo               pickable.class.name == 'Player' ? pickable.elo : nil
    json.xrank             pickable.class.name == 'Player' ? pickable.power_ranking : pickable.xrank(@draft.league.leagueable)
    json.percent_of_decks  pickable.class.name == 'Card' ? pickable.percent_of_decks(@draft.league.leagueable) : nil
    json.number_of_copies  pickable.class.name == 'Card' ? pickable.number_of_copies(@draft.league.leagueable) : nil
    json.name              pickable.name
    json.bio               pickable.class.name == 'Player' ? pickable.bio : nil
    json.image_url         pickable.class.name == 'Player' ? pickable.image_url : pickable.image_uri
    json.twitter_handle    pickable.class.name == 'Player' ? pickable.twitter_handle : nil
    json.mtg_arena_handle  pickable.class.name == 'Player' ? pickable.mtg_arena_handle : nil
    json.bio_source        pickable.class.name == 'Player' ? pickable.bio_source : nil
    json.league            pickable.class.name == 'Player' ? pickable.league : nil
    json.group             pickable.class.name == 'Player' ? pickable.group(@draft.league.leagueable) : nil
    json.pick_link         "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/picks/pick-number?pickable_id=#{pickable.id}" if current_user == @draft.league.admin || (@current_pick && current_user == @current_pick.user) || (@draft.league.draft_type != 'snake')
  end
end
