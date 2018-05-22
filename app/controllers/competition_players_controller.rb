class CompetitionPlayersController < ApplicationController

  load_and_authorize_resource
  load_and_authorize_resource :game
  load_and_authorize_resource :competition


  def index
    @players = CompetitionPlayer.where(competition_id: params[:competition_id])
  end

  def new

  end

  def import

    file = CSV.read(params[:file].path)

    file.each do |row|
      name = row[0] + " " + row[1]
      player = Player.unaccent(name)

      if player
        CompetitionPlayer.where(competition_id: @competition, player_id: player).first_or_create
      end
    end

    redirect_to game_competition_competition_players_path(@game, @competition)

  end

end
