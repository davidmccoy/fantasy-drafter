class Api::CardsController < ApplicationController
  def show
    @card = Card.find_by_id(params[:id])
  end
end
