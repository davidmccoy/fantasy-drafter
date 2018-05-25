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

  def import
    failures = []

    file = CSV.read(params[:file].path)

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
        result = Result.where(game_id: @game.id, competition_id: @competition.id, player_id: player.id).first_or_create
        result.update(points: points, place: place)
      else
        puts "No record found for #{full_name}"
        failures << row
      end
    end

    puts failures
    redirect_to game_competition_results_path
  end

end
