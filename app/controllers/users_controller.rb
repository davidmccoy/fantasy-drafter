class UsersController < ApplicationController
  before_action :set_user
  before_action :authorize_user, except: [:leagues]
  before_action :authorize_user_leagues, only: [:leagues]

  def show; end

  def leagues
    @active_single_event_leagues =
      current_user.leagues
                  .where(leagueable_type: "Competition")
                  .joins("LEFT JOIN competitions ON competitions.id = leagues.leagueable_id")
                  .where("competitions.start_date > ?", Date.today - 7.days)

    @active_season_long_leagues =
      current_user.leagues
        .where(leagueable_type: "Season")
        .joins("LEFT JOIN seasons ON seasons.id = leagues.leagueable_id")
        .where("seasons.end_date > ?", Date.today + 7.days)


    @inactive_leagues =
      current_user.leagues
        .where(leagueable_type: "Competition")
        .joins("LEFT JOIN competitions ON competitions.id = leagues.leagueable_id")
        .where("competitions.start_date < ?", Date.today - 7.days)
        .order("competitions.start_date desc")
  end

  def invites
    @invites = current_user.league_users.where(confirmed: false)
  end

  private

  def authorize_user_leagues
    if current_user
      authorize current_user, :leagues?
    else
      authorize User.new, :leagues?
    end
  end
end
