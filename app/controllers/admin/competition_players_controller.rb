class Admin::CompetitionPlayersController < ApplicationController
  require 'csv'

  before_action :set_competition
  before_action :set_competition_player
  before_action :authorize_competition_player

  def index
    @players = CompetitionPlayer.where(competition_id: @competition.id)
  end

  def new
  end

  def edit
  end

  def update
    @player = @competition_player.player

    if @player.update(player_params)
      flash[:notice] = "Successfully updated player."
    else
      flash[:alert] = "Failed to update player."
    end

    redirect_to admin_competition_competition_players_path(@competition)
  end

  def import
    file = CSV.read(params[:file].path)
    failures = []
    file.each do |row|
      puts row[0]
      puts row[1]
      name = row[0] + " " + row[1]
      player = Player.unaccent(name)

      if player
        CompetitionPlayer.where(competition_id: @competition, player_id: player).first_or_create
      else
        new_player = Player.create(name: name)
        CompetitionPlayer.where(competition_id: @competition, player_id: new_player).first_or_create
      end

      # puts row[0]
      # puts row[1]
      # name = row[0]
      # points = row[1]
      # player = Player.unaccent(name)

      # if player
      #   CompetitionPlayer.where(competition_id: @competition, player_id: player).first_or_create
      #   player.update(points: points)
      # else
      #   player = Player.create(name: name, points: points)
      #   CompetitionPlayer.where(competition_id: @competition, player_id: player).first_or_create
      # end

    end

    redirect_to admin_competition_competition_players_path(@competition)
  end

  private

  def player_params
    params.require(:player).permit(:name, :bio, :player_type)
  end
end
