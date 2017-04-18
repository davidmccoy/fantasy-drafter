class TeamsController < ApplicationController

  load_and_authorize_resource

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
