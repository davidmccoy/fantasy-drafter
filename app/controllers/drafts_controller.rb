class DraftsController < ApplicationController

  before_action :set_game
  before_action :set_competition
  before_action :set_league
  before_action :set_draft
  before_action :authorize_draft

  def show
    # redirect if not logged in
    redirect_to new_user_session_path and return unless current_user
    # redirect if user doesn't have a team
    redirect_to game_competition_league_path(@league.leagueable.game, @league.leagueable, @league) and return unless current_user.team(@league)
    # redirect if user hasn't paid entry fee
    if @league.paid_entry
      flash[:alert] = "You haven't paid the entry fee yet. Please contact us to resolve this issue."
      redirect_to game_competition_league_path(@league.leagueable.game, @league.leagueable, @league) and return unless current_user.team(@league).paid
    end
    # redirect if team has already been submitted
    redirect_to game_competition_league_path(@game, @competition, @league) and return if current_user.team(@league).submitted

    # if the user can still draft
    if (@draft.active || (Time.now > @draft.start_time if @draft.start_time)) && !@draft.completed

      if @league.draft_type == 'player'
        @available_players = @draft.league.leagueable.players.where.not(id: @draft.picks.where(pickable_type: 'Player').pluck(:pickable_id))
      elsif @league.draft_type == 'card'
        @available_players = @draft.league.leagueable.cards.where.not(id: @draft.picks.where(pickable_type: 'Card').pluck(:pickable_id))
      end

      your_next_pick = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league)&.id, pickable_id: nil).order("number ASC").first

      @your_picks = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league)&.id).order("number ASC").pluck(:number)

      @current_pick = @draft.picks.where(pickable_id: nil).sort_by{ |pick| pick.number }.first

      if your_next_pick && @current_pick
        @picks_until_your_pick = your_next_pick.number - @current_pick.number
      else
        @picks_until_your_pick = 0
      end

      @your_lineup = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league)&.id).where.not(pickable_id: nil).order("number ASC")
    elsif @draft.league.draft_type == 'pick_x'
      if @league.draft_type == 'player'
        @available_players = @draft.league.leagueable.players.where.not(id: @draft.picks.where(pickable_type: 'Player').pluck(:pickable_id))
      elsif @league.draft_type == 'card'
        @available_players = @draft.league.leagueable.cards.where.not(id: @draft.picks.where(pickable_type: 'Card').pluck(:pickable_id))
      end

      @your_picks = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league)&.id).order("id ASC").pluck(:id)

      @your_lineup = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league)&.id).where.not(pickable_id: nil).order("number ASC")
    elsif @draft.league.draft_type == 'pick_em'
      @your_picks = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league)&.id).order("id ASC").pluck(:id)
    elsif @draft.league.draft_type == 'special'
      @available_players = @draft.league.leagueable.players.where.not(id: @draft.picks.pluck(:pickable_id) )

      @your_picks = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league)&.id).order("id ASC").pluck(:id)

      @your_lineup = Pick.where(draft_id: @draft.id, team_id: current_user.team(@draft.league)&.id).where.not(pickable_id: nil).order("number ASC")
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
    redirect_to game_competition_league_path(@draft.league.leagueable.game, @draft.league.leagueable, @draft.league)
  end

  def start
    if @league.any_unconfirmed_users?
      flash[:alert] = "There are unconfirmed users."
      redirect_to game_competition_league_path(@draft.league.leagueable.game, @draft.league.leagueable, @draft.league) and return
    else
      @draft.update(active: true)
      # TODO does this need to be adjusted for timezone?
      @draft.update(start_time: Time.now) if !@draft.start_time
      @draft.create_picks

      redirect_to game_competition_league_draft_path(@draft.league.leagueable.game, @draft.league.leagueable, @draft.league, @draft)
    end
  end

  def submit
    team = current_user.team(@league)
    if @draft.league.draft_type == 'pick_em'
      pick_em_params.each do |k, match|
        users_pick = team.picks.find_by_id(Pick.where(pickable_type: 'Match', pickable_id: match['id']))
        next unless users_pick
        users_pick.update(
          winner_id: match['winner_id']
        )
      end
    end
    if team.update(submitted: true, submitted_at: Time.now)
      flash[:notice] = "You've submitted your team!"
      respond_to do |format|
        format.html { redirect_to game_competition_league_path(@game, @competition, @league) and return }
        format.json { render json: {path: game_competition_league_path(@game, @competition, @league)} }
      end
    else
      flash[:alert] = "Something went wrong with submitting your team. Please try again."
      redirect_to game_competition_league_draft_path(@game, @competition, @league, @draft) and return
    end
  end

  private

  def draft_params
    params.require(:draft).permit(:start_time)
  end

  def pick_em_params
    params.require(:matches)
  end

end
