class ResultsController < ApplicationController

  require 'csv'

  before_action :set_game
  before_action :set_competition
  before_action :set_result
  before_action :authorize_result

  def index
    @results = @competition.results.order("place ASC")
  end

  def new
  end

  def edit
  end

  def update
    if @result.update(result_params)
      flash[:notice] = "Successfully updated result."
    else
      flash[:alert] = "Failed to update result."
    end
    redirect_to game_competition_results_path(@game, @competition)
  end

  def import
    failures = []

    file = CSV.read(params[:file].path)

    if params[:resultable_type] == 'Player'
      file.each do |row|
        place = row[0].to_i
        name = row[1]
        subbed_name = nil
        points = row[2].to_i

        if name.include?("(") && name.include?("[")
          subbed_name = name.gsub!(/\([^()]*\)/,"").gsub!(/\[[^()]*\]/,"").strip.split(',')
        elsif name.include? "("
          subbed_name = name.gsub!(/\([^()]*\)/,"").strip.split(',')
        elsif name.include? "["
          subbed_name = name.gsub!(/\[[^()]*\]/,"").strip.split(',')
        end

        full_name = subbed_name[1].strip + " " + subbed_name[0].strip
        player = Player.unaccent(full_name)
        if player
          result = Result.where(game_id: @game.id, competition_id: @competition.id, resultable_id: player.id, resultable_type: 'Player').first_or_create
          result.update(points: points, place: place)
        else
          puts "No record found for #{full_name}"
          failures << row
        end
      end
    elsif params[:resultable_type] == 'Card'
      # expects '3 Teferi, Hero of Dominaria'
      file.each do |row|
        copies = row[0].split(' ')[0].to_i
        # we use scryfall's naming conventions for split cards, which is a
        # single '/' instead of two.
        card_name = row[0].split(' ').drop(1).join(' ').gsub('//', '/')

        card = Card.find_by_name(card_name)
        if card
          result = Result.where(
            game_id: @game.id,
            competition_id: @competition.id,
            resultable_id: card.id,
            resultable_type: 'Card'
          ).first_or_create

          result.update(points: result.points.to_i + copies)
        else
          failures << row
        end
      end
    end
    # file.each do |row|
    #   place = row[0].to_i
    #   name = row[1]
    #   subbed_name = nil
    #   points = row[2].to_i

    #   player = Player.unaccent(name)
    #   if player
    #     result = Result.where(game_id: @game.id, competition_id: @competition.id, player_id: player.id).first_or_create
    #     result.update(points: points, place: place)
    #   else
    #     puts "No record found for #{full_name}"
    #     failures << row
    #   end
    # end

    puts failures
    redirect_to game_competition_results_path
  end

  def team_import
    failures = []

    teams_file = CSV.read(params[:teams_file].path)
    results_file = CSV.read(params[:results_file].path)

    results_file.each do |row|
      place = row[0].to_i
      names = row[1]
      subbed_name = nil
      points = row[2].to_i

      full_players = teams_file.find_all { |el| el[3] == names }

      full_players.each do |player|
        player_name = "#{player[0]} #{player[1]}"
        player = Player.unaccent(player_name)

        if player
          result = Result.where(game_id: @game.id, competition_id: @competition.id, player_id: player.id).first_or_create
          result.update(points: points, place: place)
        else
          puts "No record found for #{player_name}"
          failures << row
        end
      end
    end

    puts failures
    redirect_to game_competition_results_path
  end

  private

  def result_params
    params.require(:result).permit(:points)
  end

end
