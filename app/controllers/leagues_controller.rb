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
    league = @competition.leagues.create(user_id: current_user.id)
    league_user = league.league_users.create(user_id: current_user.id, confirmed: true)
    league_user.create_team(name: "#{current_user.name}'s Team")
    draft = Draft.create(league_id: league.id)
    redirect_to game_competition_league_path(@competition.game, @competition, league)
  end

  def edit
  end

  def destroy
  end

end
