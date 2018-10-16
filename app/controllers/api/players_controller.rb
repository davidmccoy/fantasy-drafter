class Api::PlayersController < ApplicationController
  def show
    @player = Player.find_by_id(params[:id])
  end
end
