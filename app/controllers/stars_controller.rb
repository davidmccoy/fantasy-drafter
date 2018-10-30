class StarsController < ApplicationController

  before_action :set_game
  before_action :set_competition
  before_action :set_league
  before_action :set_draft
  before_action :set_star, except: [:index]

  def create
    @star = Star.where(star_params.merge(
      draft_id: @draft.id,
      team_id: current_user.team(@league).id
      )).first_or_create
      
    respond_to do |format|
      format.json { render @star, status: :ok}
    end
  end

  def destroy
    @old_info = @star.dup
    @star.destroy

    respond_to do |format|
      format.json { render @old_info, status: :ok}
    end
  end

  private

  def star_params
    params.permit(:starrable_type, :starrable_id)
  end

end
