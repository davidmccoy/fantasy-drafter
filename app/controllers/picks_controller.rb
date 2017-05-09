class PicksController < ApplicationController

  load_and_authorize_resource

  def update
    if @pick.user == current_user || current_user == @pick.draft.league.admin
      return false if params[:player_id] === 0
      if @pick.update(pick_params)
        # Find the next pick
        next_pick = Pick.find_by(draft_id: @pick.draft.id, number: @pick.number + 1)
        # Set the response protocol
        protocol = Rails.env.production? ? "https" : "http"
        # Construct the next pick url
        next_pick_url = Rails.application.routes.url_helpers.game_competition_league_draft_pick_url(game_id: next_pick.draft.league.leagueable.game.id, competition_id: next_pick.draft.league.leagueable.id, league_id: next_pick.draft.league.id, draft_id: next_pick.draft.id, id: next_pick.id, protocol: protocol)
        # Find the next 16 picks
        pick_order = Pick.order(:number).where(draft_id: @pick.draft).limit(16).offset(next_pick.number - 1).pluck(:team_id)

        # End draft it the last pick was made
        if @pick.number == @pick.draft.picks.count
          @pick.draft.update(active: false, completed: true)
        end

        PickMailer.next_pick(next_pick).deliver
        ActionCable.server.broadcast "draft_#{@pick.draft.id}",
          team_id: @pick.team_id,
          user_name: @pick.user.name,
          player_id: @pick.player_id,
          player_name: @pick.player.name,
          number: @pick.number,
          next_pick_user_name: next_pick.user.name,
          next_pick_team_id: next_pick.team_id,
          next_pick_id: next_pick.id,
          next_pick_url: next_pick_url,
          next_pick_number: next_pick.number,
          pick_order: pick_order
        head :ok

        # flash[:notice] = "Successfully drafted #{@pick.player.name}."
      else
        # flash[:alert] = "Pick failed."
      end
    else
      # flash[:alert] = "It's not your pick."
    end
    # redirect_to game_competition_league_draft_path(@pick.draft.league.leagueable.game, @pick.draft.league.leagueable, @pick.draft.league, @pick.draft)
  end

  private

  def pick_params
    params.permit(:player_id)
  end

end
