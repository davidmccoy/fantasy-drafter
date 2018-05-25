class TeamsController < ApplicationController

  before_action :set_game
  before_action :set_competition
  before_action :set_league
  before_action :set_team
  before_action :authorize_team

  def show
  end

  def edit
  end

  def update
    if @team.update(team_params)
      flash[:notice] = "Successfully updated team."
    else
      flash[:alert] = "Couldn't update team."
    end

    redirect_to game_competition_league_team_path(@team.league.leagueable.game, @team.league.leagueable, @team.league, @team)
  end

  private

  def team_params
    params.require(:team).permit(:name)
  end

end
