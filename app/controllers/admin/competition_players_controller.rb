class Admin::CompetitionPlayersController < ApplicationController
  require 'csv'

  before_action :set_competition
  before_action :set_competition_player
  before_action :authorize_competition_player

  def index
    @players = CompetitionPlayer.where(competition_id: @competition.id)
  end

  def new
  end

  def edit
  end

  def update
    @player = @competition_player.player

    if @player.update(player_params)
      flash[:notice] = "Successfully updated player."
    else
      flash[:alert] = "Failed to update player."
    end

    redirect_to admin_competition_competition_players_path(@competition)
  end

  def import
    file = CSV.read(params[:file].path)
    failures = []

    file.each do |row|
      if params[:bracket] == 'false'
        name = if params[:name_in_one_column] == 'true'
          row[0]
        else
          row[0] + ' ' + row[1]
        end
        player = Player.unaccent(name)

        if player
          player.update(
            mtg_arena_handle: row[2].nil? ? player.mtg_arena_handle : row[2],
            image_url: row[3].nil? ? player.image_url : row[3],
            twitter_handle: row[4].nil? ? player.twitter_handle : row[4],
            bio: row[5].nil? ? player.bio : row[5],
            bio_source: row[6].nil? ? player.bio_source : row[6],
            league: row[7].nil? ? player.league : row[7],
            country_image_url: row[8].nil? ? player.country_image_url : row[8],
            team_image_url: row[9].nil? ? player.team_image_url : row[9]
          )
          competition_player = CompetitionPlayer.where(
            competition_id: @competition,
            player_id: player
          ).first_or_create
          # competition_player.update(group: row[8])
        else
          new_player = Player.create(
            name: name,
            mtg_arena_handle: row[2],
            image_url: row[3],
            twitter_handle: row[4],
            bio: row[5],
            bio_source: row[6],
            league: row[7],
            country_image_url: row[8],
            team_image_url: row[9]
          )
          competition_player = CompetitionPlayer.where(
            competition_id: @competition,
            player_id: new_player
          ).first_or_create
          # competition_player.update(group: row[8])
        end
      elsif params[:bracket] == 'true'
        name   = row[0]
        seed   = row[1]
        group  = row[2]

        player = Player.find_by_name(name)

        if player
          competition_player = CompetitionPlayer.where(competition_id: @competition, player_id: player).first_or_create
          competition_player.update(seed: seed, group: group)
        else
          new_player = Player.create(name: name)
          competition_player = CompetitionPlayer.where(competition_id: @competition, player_id: new_player).first_or_create
          competition_player.update(seed: seed, group: group)
        end

        # player = Character.find_by_name(name)

        # if player
        #   character_competition = CharacterCompetition.where(competition_id: @competition, character_id: player).first_or_create
        #   character_competition.update(seed: seed, group: group)
        # else
        #   new_character = Character.create(name: name)
        #   character_competition = CharacterCompetition.where(competition_id: @competition, character_id: new_character).first_or_create
        #   character_competition.update(seed: seed, group: group)
        # end
      end

      # puts row[0]
      # puts row[1]
      # name = row[0]
      # points = row[1]
      # player = Player.unaccent(name)

      # if player
      #   CompetitionPlayer.where(competition_id: @competition, player_id: player).first_or_create
      #   player.update(points: points)
      # else
      #   player = Player.create(name: name, points: points)
      #   CompetitionPlayer.where(competition_id: @competition, player_id: player).first_or_create
      # end

    end

    redirect_to admin_competition_competition_players_path(@competition)
  end

  private

  def player_params
    params.require(:player).permit(:name, :bio, :player_type)
  end
end
