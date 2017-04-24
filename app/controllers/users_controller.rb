class UsersController < ApplicationController

  load_and_authorize_resource

  def show
  end

  def leagues
  end

  def invites
    @invites = current_user.league_users.where(confirmed: false)
  end

end
