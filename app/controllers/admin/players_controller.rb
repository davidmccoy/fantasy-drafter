class Admin::PlayersController < ApplicationController
  before_action :authenticate_admin

  def stats
  end

  def add_stats
    file = CSV.read(params[:file].path)

    errors = []
    file.each do |row|
      name = row[0] + " " + row[1]
      player = Player.unaccent(name)
      if player
        player.update(elo: row[2], top_25_ranking: row[4], power_ranking: row[5])
      else
        errors << name
      end
    end
    puts errors
    redirect_to admin_root_path
  end
end
