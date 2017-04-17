class DraftsController < ApplicationController

  load_and_authorize_resource

  def show
    if @draft.start_time && (@draft.active || Time.now > @draft.start_time)
      @available_players = @draft.league.competition.players.where.not(id: @draft.picks.pluck(:player_id) )

      your_next_pick = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league).id, player_id: nil).order("number ASC").first

      @current_pick = @draft.picks.where(player_id: nil).sort_by{ |pick| pick.number }.first

      @picks_until_your_pick = your_next_pick.number - @current_pick.number

      @your_lineup = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league).id).where.not(player_id: nil).order("number ASC")

    end
  end

  def update
    if @draft.update(draft_params)
      if @draft.picks.length.zero?
        @draft.create_picks
      end
      flash[:notice] = "Successfully updated the draft start time."
    else
      flash[:alert] = "Update failed."
    end
    redirect_to game_competition_league_draft_path(@draft.league.competition.game, @draft.league.competition, @draft.league, @draft)
  end

  private

  def draft_params
    params.require(:draft).permit(:start_time)
  end

end
