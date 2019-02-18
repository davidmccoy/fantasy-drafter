class Admin::LeaguesController < ApplicationController
  before_action :authenticate_admin

  def new
    @league = League.new

    if request.url.include? 'seasons'
      @leagueables = Season.where('start_date > ?', Time.now).reverse
    else
      @leagueables = Competition.where('start_date > ?', Time.now).reverse
    end
  end

  def create
    @league = League.new(league_params.merge(
                           user_id: current_user.id
                         ))
    if @league.save
      draft = Draft.create(league_id: @league.id)
      flash[:notice] = "Successfully created league."
    else
      flash[:alert] = "Failed to create league."
      redirect_to new_admin_league_path and return
    end

    redirect_to admin_root_path
  end

  private

  def league_params
    params.require(:league).permit(:leagueable_id, :leagueable_type, :draft_type, :public, :num_draft_rounds, :name, :pick_type, :paid_entry, :entry_fee)
  end
end
