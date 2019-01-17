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
        full_name = nil
        points = row[2].to_i

        if name.include?("(") && name.include?("[")
          subbed_name = name.gsub!(/\([^()]*\)/,"").gsub!(/\[[^()]*\]/,"").strip.split(',')
        elsif name.include? "("
          subbed_name = name.gsub!(/\([^()]*\)/,"").strip.split(',')
        elsif name.include? "["
          subbed_name = name.gsub!(/\[[^()]*\]/,"").strip.split(',')
        end

        if subbed_name
          full_name = subbed_name[1].strip + " " + subbed_name[0].strip
        else
          full_name = name
        end
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
        copies = file[0][0].split(' ')[0].to_i
        match_points = file[0][1].to_i
        card_points = match_points ? match_points * copies : copies
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

          result.update(points: result.points.to_i + card_points)
        else
          failures << row
        end
      end
    elsif params[:resultable_type] == 'Match'
      file.each do |row|
        player_one_name = row[0].strip
        player_two_name = row[1].strip
        winner_name     = row[2].strip

        player_one = Player.find_by_name(player_one_name)
        player_two = Player.find_by_name(player_two_name)
        winner = player_one_name == winner_name ? player_one : player_two
        if player_one && player_two
          match = @competition.matches.where('(player_a_id = ? OR player_b_id = ?) AND (player_a_id = ? OR player_b_id = ?)', player_one.id, player_one.id, player_two.id, player_two.id).first

          match.update(winner_id: winner.id) if match
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
