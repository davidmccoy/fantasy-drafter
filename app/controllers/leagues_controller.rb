class LeaguesController < ApplicationController

  before_action :set_game
  before_action :set_competition
  before_action :set_league, except: [:index, :new, :create]
  before_action :authorize_league, except: [:index, :show]
  before_action :show_public_leagues, only: [:show]

  def index
  end

  def show
    @pagy, @teams = pagy(@league.standings)
  end

  def new
    @pick_options = []
    @pick_options << ["Cards", "card"] unless @competition.cards.empty?
    @pick_options << ["Players", "player"] unless @competition.players.empty?
  end

  def create
    league = @competition.leagues.create(league_params.merge(user_id: current_user.id))
    league_user = league.league_users.create(user_id: current_user.id, confirmed: true)
    team = league_user.create_team(name: "#{current_user.name}'s Team")
    draft = Draft.create(league_id: league.id)
    if league.draft_type == 'pick_x'
      league.num_draft_rounds.times {
        Pick.create(
          draft_id: league.draft.id,
          team_id: team.id,
          pickable_type: league.pick_type&.classify
        )
      }
    elsif league.draft_type == 'pick_em'
      league.leagueable.matches.each do |match|
        Pick.create(
          draft_id: league.draft.id,
          team_id: team.id,
          pickable_type: 'Match',
          pickable_id: match.id
        )
      end
    end
    User.where(admin: true).each do |user|
      AdminMailer.new_league(league, user.email).deliver_later
    end
    redirect_to game_competition_league_path(@competition.game, @competition, league)
  end

  def edit
  end

  def update
    if @league.update(league_params.merge(
      draft_attributes: {
        start_time: league_params[:draft_attributes][:start_time]&.to_time&.utc,
        id: league_params[:draft_attributes][:id]
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

  def join
    redirect_to game_competition_league_path(@game, @competition, @league) if current_user.leagues.include? @league
    @league_user = LeagueUser.new
  end

  def group_invite
    invite = Invite.create(
      league_id: @league.id,
      for_group: true
    )

    if invite
      flash[:notice] = "Successfully created group invite link."
    else
      flash[:alert] = "Failed to create group invite link."
    end

    redirect_to game_competition_league_league_users_path(@game, @competition, @league) and return
  end

  private

  def league_params
    params.require(:league).permit(:num_draft_rounds, :draft_type, :pick_type,
      :name, draft_attributes: [:id, :start_time])
  end

end
