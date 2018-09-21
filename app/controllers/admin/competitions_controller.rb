class Admin::CompetitionsController < ApplicationController
  before_action :authenticate_admin

  def new
    @competition = Competition.new
  end

  def create
    @competition = Competition.new(competition_params.merge(
                                    date: competition_params[:date].to_time.utc
                                   ))
    if @competition.save
      flash[:notice] = "Successfully created competition."
    else
      flash[:alert] = "Failed to create competition."
      redirect_to new_admin_competition_path and return
    end

    redirect_to admin_root_path
  end

  def edit
    @competition = Competition.find_by(slug: params[:slug])
  end

  def update
    @competition = Competition.find_by(slug: params[:slug])
    if @competition.update(competition_params)
      flash[:notice] = "Successfully updated #{@competition.name}."
      redirect_to admin_root_path(@competition) and return
    else
      flash[:alert] = "Failed to update #{@competition.name}."
      redirect_to admin_edit_competition_path(@competition) and return
    end
  end

  private

  def competition_params
    params.require(:competition).permit(:game_id, :name, :slug, :date, :location, :score_as_of_round)
  end
end
