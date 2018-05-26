class LeaguesController < ApplicationController

  before_action :set_game
  before_action :set_competition
  before_action :set_league, except: [:index, :new, :create]
  before_action :authorize_league

  def index
  end

  def show
  end

  def new
  end

  def create
    league = @competition.leagues.create(league_params.merge(user_id: current_user.id))
    league_user = league.league_users.create(user_id: current_user.id, confirmed: true)
    league_user.create_team(name: "#{current_user.name}'s Team")
    draft = Draft.create(league_id: league.id)
    AdminMailer.new_league(league).deliver_later
    redirect_to game_competition_league_path(@competition.game, @competition, league)
  end

  def edit
  end

  def update
    if @league.update(league_params.merge(
      draft_attributes: {
        start_time: league_params[:draft_attributes][:start_time].to_time.utc
      }
    ))
      flash[:notice] = "Successfully updated your league."
    else
      flash[:alert] = "Failed to update your league."
    end

    redirect_to game_competition_league_path(@game, @competition, @league)
  end

  def destroy
  end

  def league_params
    params.require(:league).permit(:num_draft_rounds, draft_attributes: [:start_time])
  end

end
