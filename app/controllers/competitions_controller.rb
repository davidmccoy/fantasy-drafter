class CompetitionsController < ApplicationController

  before_action :set_game
  before_action :set_competition, except: [:index]
  before_action :authorize_competition

  def index
    @competitions = Competition.all
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
    params.require(:competition).permit(:name, :date, :location, :slug)
  end

end
