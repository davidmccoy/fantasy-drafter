class PicksController < ApplicationController

  load_and_authorize_resource

  def update
    if @pick.user == current_user || current_user == @pick.draft.tournament.admin
      if @pick.update(pick_params)
        next_pick = Pick.find_by(draft_id: @pick.draft.id, number: @pick.number + 1)
        protocol = Rails.env.production? ? "https" : "http"

        next_pick_url = Rails.application.routes.url_helpers.game_competition_tournament_draft_pick_url(game_id: next_pick.draft.tournament.competition.game.id, competition_id: next_pick.draft.tournament.competition.id, tournament_id: next_pick.draft.tournament.id, draft_id: next_pick.draft.id, id: next_pick.id, protocol: protocol)

        your_pick = next_pick.user == current_user || current_user == next_pick.draft.tournament.admin

        if @pick.number == @pick.draft.picks.count
          @pick.draft.update(active: false, completed: true)
        end
        PickMailer.next_pick(next_pick).deliver_later
        ActionCable.server.broadcast 'picks',
          user_id: @pick.user_id,
          user_name: @pick.user.name,
          player_id: @pick.player_id,
          player_name: @pick.player.name,
          number: @pick.number,
          next_pick_user_name: next_pick.user.name,
          next_pick_id: next_pick.id,
          next_pick_url: next_pick_url,
          next_pick_number: next_pick.number,
          your_pick: your_pick
        head :ok

        # flash[:notice] = "Successfully drafted #{@pick.player.name}."
      else
        # flash[:alert] = "Pick failed."
      end
    else
      # flash[:alert] = "It's not your pick."
    end
    # redirect_to game_competition_tournament_draft_path(@pick.draft.tournament.competition.game, @pick.draft.tournament.competition, @pick.draft.tournament, @pick.draft)
  end

  private

  def pick_params
    params.permit(:player_id)
  end

end
