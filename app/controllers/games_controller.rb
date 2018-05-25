class GamesController < ApplicationController

  before_action :set_game, except: [:index]
  before_action :authorize_game, except: [:index]

  def index
    @games = Game.all
  end

  def new

  end

end
