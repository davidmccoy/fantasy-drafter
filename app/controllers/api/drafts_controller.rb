class Api::DraftsController < ApplicationController
  before_action :set_draft

  def available_players
    if !@draft.completed
      @available_players = @draft.league.leagueable.players
      .where.not(
        id: @draft.picks.pluck(:player_id)
      )

      @current_pick = @draft.picks
      .where(player_id: nil)
      .sort_by{ |pick| pick.number }.first
    else
      @available_players = nil
      @current_pick = nil
    end
  end

  def all_teams
    current_team = @draft.league.teams.find_by_id(current_user.team(@draft.league))
    @my_team = {
      user_id: current_user.id,
      team_id: current_team.id,
      name: current_team.name,
      players: current_team.players
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
