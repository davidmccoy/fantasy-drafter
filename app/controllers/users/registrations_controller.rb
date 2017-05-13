class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters

  def create
    super

    if @user.save
      if params[:league_id] && params[:invite_id]
        league = League.find(params[:league_id])
        league_user = league.league_users.create(user_id: @user.id, confirmed: true)
        league_user.create_team(name: "#{@user.name}'s Team")

        invite = Invite.find(params[:invite_id])
        invite.update(invited_user_id: @user.id, accepted: true, token: nil)
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation])
  end
end
