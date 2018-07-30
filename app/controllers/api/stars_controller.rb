class Api::StarsController < ApplicationController
  before_action :set_draft

  def index
    @stars = Star.where(team_id: current_user.team(@draft.league), draft_id: @draft.id).where.not(player_id: @draft.picks.pluck(:player_id))
  end
end
