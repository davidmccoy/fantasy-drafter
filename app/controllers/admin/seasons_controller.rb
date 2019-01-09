class Admin::SeasonsController < ApplicationController
  before_action :authenticate_admin

  def index
    @seasons = Season.all
  end

  def new
    @season = Season.new
  end

  def create
    if Season.create(season_params)
      flash[:notice] = "Successfully created season."
    else
      flash[:alert] = "Failed to create season."
      redirect_to new_admin_season_path and return
    end

    redirect_to admin_root_path
  end

  def edit
    @season = Season.find_by_id(params[:id])
  end

  def update
    @season = Season.find_by_id(params[:id])
    if @season.update(season_params)
      flash[:notice] = "Successfully updated season."
    else
      flash[:alert] = "Failed to update season."
      redirect_to edit_admin_season_path(@season) and return
    end

    redirect_to admin_root_path
  end

  private

  def season_params
    params.require(:season).permit(:game_id, :name, :slug, :start_date, :end_date)
  end
end
