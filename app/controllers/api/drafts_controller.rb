class Api::DraftsController < ApplicationController
  before_action :set_draft

  def available_players
    if !@draft.completed
      if @draft.league.draft_type == 'snake'
        @available_players = @draft.league.leagueable.players
        .where.not(
          id: @draft.picks.pluck(:player_id)
        )

        @current_pick = @draft.picks
        .where(player_id: nil)
        .sort_by{ |pick| pick.number }.first
      else
        @available_players = @draft.league.leagueable.players.where.not(
          id: current_user.team(@draft.league).players.pluck(:id)
        )

        @current_pick = @draft.picks
        .where(player_id: nil)
        .sort_by{ |pick| pick.number }.first
      end
    else
      @available_players = nil
      @current_pick = nil
    end
  end

  def all_teams
    current_team = @draft.league.teams.find_by_id(current_user.team(@draft.league))
    current_team_players = current_team.players.order(:power_ranking).map { |player| {name: player.name, elo: player.elo, power_ranking: player.power_ranking, delete_link: "/games/mtg/competitions/ptdom/leagues/#{@draft.league.id}/drafts/#{@draft.id}/picks/remove_player?pick_id=#{@draft.picks.find_by(player_id: player.id, team_id: current_team.id).id}&player_id=nil" } }
    Pick.where(team_id: current_team.id, player_id: [nil, 0]).count.times do
      current_team_players << { name: nil, delete_link: nil }
    end

    @my_team = {
      user_id: current_user.id,
      team_id: current_team.id,
      name: current_team.name,
      players: current_team_players
    }

    @teams = []
    @draft.league.teams.where.not(id: current_user.team(@draft.league)).each do |team|
      players = []
      team.players.each do |player|
        players << {
          id: player.id,
          name: player.name
        }
      end
      @teams << {
        user_id: team.user.id,
        team_id: team.id,
        name: team.name,
        players: players
      }
    end
  end

  def show
  end

  private

  def set_draft
    @draft = Draft.find_by_id(params[:draft_id]) || Draft.find_by_id(params[:id])
  end
end
