class PicksController < ApplicationController

  load_and_authorize_resource

  def update
    if @pick.update(pick_params)
      flash[:notice] = "Successfully drafted #{@pick.player.name}."
    else
      flash[:alert] = "Pick failed."
    end
    redirect_to game_competition_tournament_draft_path(@pick.draft.tournament.competition.game, @pick.draft.tournament.competition, @pick.draft.tournament, @pick.draft)
  end

  private

  def pick_params
    params.permit(:player_id)
  end

end
