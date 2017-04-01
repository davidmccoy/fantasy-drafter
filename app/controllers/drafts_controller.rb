class DraftsController < ApplicationController

  load_and_authorize_resource

  def show
  end

  def update
    if @draft.update(draft_params)
      flash[:notice] = "Successfully updated the draft start time."
    else
      flash[:alert] = "Update failed."
    end
    redirect_to game_competition_tournament_draft_path(@draft.tournament.competition.game, @draft.tournament.competition, @draft.tournament, @draft)
  end

  private

  def draft_params
    params.require(:draft).permit(:start_time)
  end

end
