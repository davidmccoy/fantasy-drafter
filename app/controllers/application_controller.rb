class ApplicationController < ActionController::Base
  include Pundit
  include Pagy::Backend

  protect_from_forgery with: :exception


  before_action -> { flash.now[:notice] = flash[:notice].html_safe if flash[:html_safe] && flash[:notice] }

  before_action -> { flash.now[:alert] = flash[:alert].html_safe if flash[:html_safe] && flash[:alert] }

  before_action :capture_referral

  around_action :with_timezone

  after_action :store_location

  helper_method :authenticate_admin, :markdown

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def capture_referral
    session[:referral_code] = params[:referral_code] if params[:referral_code]
  end

  # use Pundit to redirect after failed auth
  def user_not_authorized
    if current_user
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to(request.referrer || root_path) and return
    else
      flash[:alert] = "You'll have to sign in before you can do that!"
      redirect_to new_user_session_path(url: request.path) and return
    end
  end

  def admin_signed_in?
    signed_in? && current_user.admin
  end

  def authenticate_admin
    unless admin_signed_in?
      redirect_to request.referer || root_path
    end
  end

  # store location for Devise to redirect to after sign in
  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end

  # customize Devise's sign in path
  def after_sign_in_path_for(resource)
    if params[:league_id] && params[:invite_id]
      invite = Invite.find_by_id(params[:invite_id])
      invite_path(invite, token: invite.token)
    else
      params[:url] || session[:previous_url] || root_path
    end
  end

  # store client's timezone
  def with_timezone
    timezone = Time.find_zone(cookies[:timezone])
    Time.use_zone(timezone) { yield }
  end

  # ======= custom methods to set records and authorize them ======= #

  def set_user
    @user = User.find_by_id(params[:user_id]) || User.find_by_id(params[:id])
  end

  def authorize_user
    @user ||= User.new
    authorize @user
  end

  def set_invite
    @invite = Invite.find_by_id(params[:invite_id]) || Invite.find_by_id(params[:id])
  end

  def set_game
    @game = Game.find_by(slug: params[:game_slug]) || Game.find_by(slug: params[:slug])
  end

  def authorize_game
    @game ||= Game.new
    authorize @game
  end

  def set_player
    @player = Player.find_by_id(params[:player_id]) || Player.find_by_id(params[:id])
  end

  def authorize_player
    @player ||= Player.new
    authorize @player
  end

  def set_season
    @season = Season.find_by(slug: params[:season_slug]) || Season.find_by(slug: params[:slug])
  end

  def set_competition
    @competition = Competition.find_by(slug: params[:competition_slug]) || Competition.find_by(slug: params[:slug])
  end

  def authorize_competition
    @competition ||= Competition.new
    authorize @competition
  end

  def set_competition_player
    @competition_player = CompetitionPlayer.find_by_id(params[:competition_player_id]) || CompetitionPlayer.find_by_id(params[:id])
  end

  def authorize_competition_player
    @competition_player ||= CompetitionPlayer.new
    authorize @competition_player
  end

  def set_result
    @result = Result.find_by_id(params[:result_id]) || Result.find_by_id(params[:id])
  end

  def authorize_result
    @result ||= Result.new
    authorize @result
  end

  def set_league
    @league = League.find_by_id(params[:league_id]) || League.find_by_id(params[:id])
  end

  def authorize_league
    @league ||= League.new
    authorize @league
  end

  def show_public_leagues
    @league ||= League.new
    authorize @league unless @league.public
  end

  def set_league_user
    @league_user = LeagueUser.find_by_id(params[:league_user_id]) || LeagueUser.find_by_id(params[:id])
  end

  def authorize_league_user
    @league_user ||= LeagueUser.new(league_id: @league.id)
    authorize @league_user
  end

  def set_team
    @team = Team.find_by_id(params[:team_id]) || Team.find_by_id(params[:id])
  end

  def authorize_team
    @team ||= Team.new
    authorize @team
  end

  def set_draft
    @draft = Draft.find_by_id(params[:draft_id]) || Draft.find_by_id(params[:id])
  end

  def authorize_draft
    @draft ||= Draft.new
    authorize @draft
  end

  def set_pick
    @pick = Pick.find_by_id(params[:pick_id]) || Pick.find_by_id(params[:id])
  end

  def authorize_pick
    @pick ||= Pick.new
    authorize @pick
  end

  def set_star
    @star = Star.find_by_id(params[:star_id]) || Star.find_by_id(params[:id])
  end

  # TODO authorize_star

  def markdown text
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                       no_intra_emphasis: true,
                                       fenced_code_blocks: true,
                                       disable_indented_code_blocks: true,
                                       autolink: true,
                                       tables: true,
                                       underline: true,
                                       highlight: true
                                      )
    return markdown.render(text).html_safe
  end
end
