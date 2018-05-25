class UsersController < ApplicationController

  before_action :set_user
  before_action :authorize_user, except: [:leagues]
  before_action :authorize_user_leagues, only: [:leagues]

  def show
  end

  def leagues
  end

  def invites
    @invites = current_user.league_users.where(confirmed: false)
  end

  private

  def authorize_user_leagues
    authorize current_user, :leagues?
  end

end
