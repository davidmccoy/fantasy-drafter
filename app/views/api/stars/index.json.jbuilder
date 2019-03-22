json.stars @stars do |star|
  json.star_link "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/stars/#{star.id}"
  json.id star.id
  json.name              star.starrable.name
  json.bio               star.starrable.class.name == 'Player' ? star.starrable.bio : nil
  json.image_url         star.starrable.class.name == 'Player' ? star.starrable.image_url : nil
  json.twitter_handle    star.starrable.class.name == 'Player' ? star.starrable.twitter_handle : nil
  json.mtg_arena_handle  star.starrable.class.name == 'Player' ? star.starrable.mtg_arena_handle : nil
  json.bio_source        star.starrable.class.name == 'Player' ? star.starrable.bio_source : nil
  json.mpl_member        star.starrable.class.name == 'Player' ? star.starrable.mpl_member : nil
  json.group             star.starrable.class.name == 'Player' ? star.starrable.group(@draft.league.leagueable) : nil
  json.player_id star.starrable.id
  json.starrable_type star.starrable_type
  json.elo star.starrable_type == 'Player' ? star.starrable.elo : nil
  json.xrank star.starrable_type == 'Player' ? star.starrable.power_ranking : star.starrable.xrank(star.draft.league.leagueable)
  json.percent_of_decks star.starrable_type == 'Card' ? star.starrable.percent_of_decks(star.draft.league.leagueable) : nil
  json.number_of_copies star.starrable_type == 'Card' ? star.starrable.number_of_copies(star.draft.league.leagueable) : nil
  json.pick_link "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/picks/pick-number?pickable_id=#{star.starrable.id}"
end
