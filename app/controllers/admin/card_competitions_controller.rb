class Admin::CardCompetitionsController < ApplicationController
  require 'csv'

  before_action :authenticate_admin
  before_action :set_competition
  # before_action :set_competition_player

  def index
    @cards = CardCompetition.where(competition_id: @competition.id)
  end

  def new
  end

  def edit
  end

  def update
    # @player = @competition_player.player

    # if @player.update(player_params)
    #   flash[:notice] = "Successfully updated player."
    # else
    #   flash[:alert] = "Failed to update player."
    # end

    # redirect_to admin_competition_competition_players_path(@competition)
  end

  def import
    file = CSV.read(params[:file].path)
    failures = []
    file.each do |row|
      card_name = row[0]
      percent_of_decks = row[1]
      number_of_copies = row[2]
      xrank = row[4]
      card = Card.find_by_name(card_name)
      
      if card
        card_competition = CardCompetition.where(
            competition_id: @competition, 
            card_id: card
          ).first_or_create
        card_competition.update(
            percent_of_decks: percent_of_decks,
            number_of_copies: number_of_copies,
            xrank: xrank
          )
      else
        failures << card_name
      end
    end
    p failures 
    redirect_to admin_competition_card_competitions_path(@competition)
  end

  private

  def card_params
    params.require(:card).permit(:name)
  end
end
