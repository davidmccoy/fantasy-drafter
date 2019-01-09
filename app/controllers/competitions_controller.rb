class CompetitionsController < ApplicationController

  before_action :set_game
  before_action :set_competition, except: [:index]
  before_action :authorize_competition, except: [:index]

  def index
    @competitions = Competition.all
    @seasons = Season.where('start_date > ?', Time.now).reverse
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

  def show
  end

  def edit
  end

  def update
    if @competition.update(competition_params)
      flash[:notice] = "Successfully updated #{@competition.name}."
      redirect_to game_competition_path(@game, @competition) and return
    else
      flash[:alert] = "Failed to update #{@competition.name}."
      redirect_to edit_game_competition_path(@game, @competition) and return
    end
  end

  private

  def competition_params
    params.require(:competition).permit(:name, :date, :location, :slug, :score_as_of_round)
  end

end
