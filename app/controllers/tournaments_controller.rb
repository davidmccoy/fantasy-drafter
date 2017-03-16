class TournamentsController < ApplicationController

  load_and_authorize_resource
  # sets @competition for all actions
  load_and_authorize_resource :competition

  def index
  end

  def new
  end

  def create
    tournament = @competition.tournaments.create(user_id: current_user.id)
    redirect_to game_competition_tournament_path(@competition.game, @competition, tournament)
  end

  def edit
  end

  def destroy
  end

end
