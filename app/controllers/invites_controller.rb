class InvitesController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_invite

  def show
    if @invite.token == params[:token]
      if params[:errors]&.include? "password"
        @password_message = "Your password is #{params[:errors][:password].first[:error]&.humanize&.downcase}. The minimum length is #{params[:errors][:password].first[:count]&.humanize&.downcase}."
      end

      if params[:errors]&.include? "password_confirmation"
        @password_confirmation_message = "Your passwords don't match."
      end
    else
      flash[:alert] = "Invalid invite."
      redirect_to root_path
    end
  end

  def create
    invite = Invite.where(invite_params).first_or_create
    league = League.find(params[:league_id])

    # TODO fails because Invites use User ids rather than email
    if invite.save
      flash[:notice] = "Invite sent to #{params[:email]}."
    else
      flash[:alert] = "Invite to #{params[:email]} failed to send."
    end
    redirect_to game_competition_league_league_users_path(league.leagueable.game, league.leagueable, league)
  end

  def resend

  end

  private

  def invite_params
    params.permit(:email, :league_id)
  end

end
