class Api::DraftsController < ApplicationController
  before_action :set_draft

  def available_players
    @available_players = @draft.league.leagueable.players
                          .where.not(
                            id: @draft.picks.pluck(:player_id)
                          )

    @current_pick = @draft.picks
                      .where(player_id: nil)
                      .sort_by{ |pick| pick.number }.first
  end

  private

  def set_draft
    @draft = Draft.find_by_id(params[:draft_id]) || Draft.find_by_id(params[:id])
  end
end
