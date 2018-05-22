class CompetitionsController < ApplicationController

  load_and_authorize_resource
  # sets @game
  load_and_authorize_resource :game

  def index

  end

  def new
    @competition = Competition.new
  end

  def create
    @competition = Competition.new(competition_params.merge(
      game_id: @game.id
      ))

    if @competition.save
      flash[:notice] = "Successfully created competition."
      redirect_to game_competition_competition_players_path(@game, @competition) and return
    else
      flash[:alert] = "Failed to create competition."
      redirect_to new_game_competition_path(@game) and return
    end
  end

  private

  def competition_params
    params.require(:competition).permit(:name, :date, :location)
  end

end
