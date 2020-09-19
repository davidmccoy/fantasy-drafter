class StandingsController < ApplicationController
  before_action :set_game
  before_action :set_season

  def index
    mpl_ids = Player.where(league: 'MPL').pluck(:id)
    rivals_ids = Player.where(league: 'Rivals').pluck(:id)

    @mpl_standings = @season.standings
                            .where(player_id: mpl_ids)
                            .order('place asc')

    @projected_mpl = @season.standings
                            .where(qualifies_for: '2020-21 Magic Pro League')
                            .order("CASE qualifies_via WHEN 'Won World Championship XXVI' THEN '1' WHEN 'Top 16 of the 2020 MPL' THEN '2' WHEN 'Top Rival by Player Points' THEN '3' WHEN 'Top Rival by Mythic Points' THEN '4' END")
                            .order('total_points desc')

    @rivals_standings = @season.standings.where(player_id: rivals_ids).order('place asc')

    @projected_rivals = @season.standings
                                .where(qualifies_for: '2020-21 Magic Rivals League')
                                .order('total_points desc')
  end
end