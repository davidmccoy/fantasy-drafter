json.star do
  json.star_link "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/stars/#{@star.id}"
  json.id @star.id
  json.name @star.player.name
  json.player_id @star.player.id
  json.elo @star.player.elo
  json.power_ranking @star.player.power_ranking
  json.pick_link "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/picks/pick-number?player_id=#{@star.player.id}"
end
