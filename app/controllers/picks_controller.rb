class PicksController < ApplicationController

  load_and_authorize_resource

  def update
    if @pick.user == current_user || current_user = @pick.draft.tournament.admin
      if @pick.update(pick_params)
        if @pick.number == @pick.draft.picks.count
          @pick.draft.update(active: false, completed: true)
        end
        flash[:notice] = "Successfully drafted #{@pick.player.name}."
      else
        flash[:alert] = "Pick failed."
      end
    else
      flash[:alert] = "It's not your pick."
    end
    redirect_to game_competition_tournament_draft_path(@pick.draft.tournament.competition.game, @pick.draft.tournament.competition, @pick.draft.tournament, @pick.draft)
  end

  private

  def pick_params
    params.permit(:player_id)
  end

end
