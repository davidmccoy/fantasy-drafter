class Seasons::DraftsController < ApplicationController

  before_action :set_game
  before_action :set_season
  before_action :set_league
  before_action :set_draft
  before_action :authorize_draft

  def show
    redirect_to new_user_session_path and return unless current_user
    redirect_to game_season_league_path(@game, @season, @league) and return if current_user.team(@league).submitted
    if (@draft.active || (Time.now > @draft.start_time if @draft.start_time)) && !@draft.completed
      @available_players = @draft.league.leagueable.players.where.not(id: @draft.picks.pluck(:player_id) )

      your_next_pick = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league)&.id, player_id: nil).order("number ASC").first

      @your_picks = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league)&.id).order("number ASC").pluck(:number)

      @current_pick = @draft.picks.where(player_id: nil).sort_by{ |pick| pick.number }.first

      if your_next_pick && @current_pick
        @picks_until_your_pick = your_next_pick.number - @current_pick.number
      else
        @picks_until_your_pick = 0
      end

      @your_lineup = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league)&.id).where.not(player_id: nil).order("number ASC")
    elsif @draft.league.draft_type == 'pick_x'
      @available_players = @draft.league.leagueable.players.where.not(id: @draft.picks.pluck(:player_id) )

      @your_picks = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league)&.id).order("id ASC").pluck(:id)

      @your_lineup = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league)&.id).where.not(player_id: nil).order("number ASC")
    end
  end

  def update
    if @draft.update(draft_params.merge(
      start_time: draft_params[:start_time].to_time.utc
      ))
      # if @draft.picks.length.zero?
      #   @draft.create_picks
      # end
      flash[:notice] = "Successfully updated the draft start time."
    else
      flash[:alert] = "Update failed."
    end
    redirect_to game_season_league_path(@draft.league.leagueable.game, @draft.league.leagueable, @draft.league)
  end

  def start
    if @league.any_unconfirmed_users?
      flash[:alert] = "There are unconfirmed users."
      redirect_to game_season_league_path(@draft.league.leagueable.game, @draft.league.leagueable, @draft.league) and return
    else
      @draft.update(active: true)
      # TODO does this need to be adjusted for timezone?
      @draft.update(start_time: Time.now) if !@draft.start_time
      @draft.create_picks

      redirect_to game_season_league_draft_path(@draft.league.leagueable.game, @draft.league.leagueable, @draft.league, @draft)
    end
  end

  def submit
    team = current_user.team(@league)
    if team.update(submitted: true, submitted_at: Time.now)
      flash[:notice] = "You've submitted your team!"
      redirect_to game_season_league_path(@game, @season, @league) and return
    else
      flash[:alert] = "Something went wrong with submitting your team. Please try again."
      redirect_to game_season_league_draft_path(@game, @season, @league, @draft) and return
    end
  end

  private

  def draft_params
    params.require(:draft).permit(:start_time)
  end

end
