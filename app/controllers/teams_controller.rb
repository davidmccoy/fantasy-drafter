class TeamsController < ApplicationController

  before_action :set_game
  before_action :set_competition
  before_action :set_league
  before_action :set_team
  before_action :authorize_team

  def show
    if @league.pick_type == 'player'
      @players = @team.players 
      @player_type = 'Player'
    elsif @league.pick_type == 'card'
      @players = @team.cards
      @player_type = 'Card'
    end 
  end

  def edit
  end

  def update
    if @team.update(team_params)
      flash[:notice] = "Successfully updated team."
      redirect_to game_competition_league_team_path(@team.league.leagueable.game, @team.league.leagueable, @team.league, @team) and return
    else
      flash[:alert] = @team.errors.messages
      redirect_to edit_game_competition_league_team_path(@team.league.leagueable.game, @team.league.leagueable, @team.league, @team) and return
    end

  end

  private

  def team_params
    params.require(:team).permit(:name, :supporting)
  end

end
