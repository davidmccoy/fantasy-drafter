class ResultsController < ApplicationController

  require 'csv'

  load_and_authorize_resource

  def index
    @game = Game.find_by_id(params[:game_id])
    @competition = Competition.find_by_id(params[:competition_id])
    @results = @competition.results.order("points DESC")
  end

  def new
    @game = Game.find_by_id(params[:game_id])
    @competition = Competition.find_by_id(params[:competition_id])
  end

  def import
    @game = Game.find_by_id(params[:game_id])
    @competition = Competition.find_by_id(params[:competition_id])
    failures = []

    file = CSV.read(params[:file].path)

    file.each do |row|
      name = row[0]
      subbed_name = nil
      points = row[1].to_i

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
        result = Result.where(game_id: @game.id, competition_id: @competition.id, player_id: player.id).first_or_create
        result.update(points: points)
      else
        puts "No record found for #{full_name}"
        failures << row
      end
    end

    puts failures
    redirect_to game_competition_results_path
  end

end
