json.stars @stars do |star|
  json.star_link "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/stars/#{star.id}"
  json.id star.id
  json.name star.player.name
  json.player_id star.player.id
  json.pick_link "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/picks/pick-number?player_id=#{star.player.id}"
end
