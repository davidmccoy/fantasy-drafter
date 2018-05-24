class DraftsController < ApplicationController

  load_and_authorize_resource

  def show
    redirect_to new_user_session_path and return unless current_user
    if (@draft.active || (Time.now > @draft.start_time if @draft.start_time)) && !@draft.completed
      @available_players = @draft.league.leagueable.players.where.not(id: @draft.picks.pluck(:player_id) )

      your_next_pick = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league).id, player_id: nil).order("number ASC").first

      @current_pick = @draft.picks.where(player_id: nil).sort_by{ |pick| pick.number }.first

      if your_next_pick && @current_pick
        @picks_until_your_pick = your_next_pick.number - @current_pick.number
      else
        @picks_until_your_pick = 0
      end

      @your_lineup = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league).id).where.not(player_id: nil).order("number ASC")

    end
  end

  def update
    if @draft.update(draft_params)
      # if @draft.picks.length.zero?
      #   @draft.create_picks
      # end
      flash[:notice] = "Successfully updated the draft start time."
    else
      flash[:alert] = "Update failed."
    end
    redirect_to game_competition_league_draft_path(@draft.league.leagueable.game, @draft.league.leagueable, @draft.league, @draft)
  end

  def start
    @draft = Draft.find_by_id(params[:draft_id])
    @draft.update(active: true)
    @draft.update(start_time: Time.now) if !@draft.start_time
    @draft.create_picks

    redirect_to game_competition_league_draft_path(@draft.league.leagueable.game, @draft.league.leagueable, @draft.league, @draft)
  end

  private

  def draft_params
    params.require(:draft).permit(:start_time)
  end

end
