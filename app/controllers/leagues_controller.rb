class LeaguesController < ApplicationController

  load_and_authorize_resource
  # sets @competition for all actions
  load_and_authorize_resource :competition

  def index
  end

  def new
  end

  def create
    league = @competition.leagues.create(user_id: current_user.id)
    league.league_users.create(user_id: current_user.id)
    draft = Draft.create(league_id: league.id)
    redirect_to game_competition_league_path(@competition.game, @competition, league)
  end

  def edit
  end

  def destroy
  end

end
