class CompetitionsController < ApplicationController

  load_and_authorize_resource
  # sets @game
  load_and_authorize_resource :game

  def index

  end

end
