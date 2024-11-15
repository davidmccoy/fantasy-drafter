class PlayersController < ApplicationController

  require 'csv'

  before_action :set_player
  before_action :authorize_player

  def new

  end

  def import
    file = CSV.read(params[:file].path)

    players = []
    file.each do |row|
      name = row[0].strip
      player = Player.unaccent(name)

      if !player
        Player.create(name: name)
        players << name
      end
    end
    puts players

    redirect_to new_player_path
  end
end
