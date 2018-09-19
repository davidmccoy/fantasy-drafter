class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        AdminMailer.new_user(@user).deliver_later
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)

        if @user.save
          begin
            Gibbon::Request.lists('4f6afd7475').members.create(body: { email_address: subscriber_params[:email], status: 'subscribed' }) if Rails.env.production?
          rescue => e
            puts 'failed to subscribe to mailchimp'
          end
          if params[:league_id] && params[:invite_id]
            league = League.find(params[:league_id])
            league_user = league.league_users.create(user_id: @user.id, confirmed: true)
            league_user.create_team(name: "#{@user.name}'s Team")

            if league.draft_type == 'pick_x'
              team = league_user.team
              league.num_draft_rounds.times {
                Pick.create(
                  draft_id: league.draft.id,
                  team_id: team.id
                )
              }
            end

            invite = Invite.find(params[:invite_id])
            invite.update(accepted: true, token: nil)

            redirect_to game_competition_league_path(league.leagueable.game, league.leagueable, league) and return
          else
            respond_with resource, location: after_sign_up_path_for(resource) and return
          end
        end
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      if request.referrer.include? "invites"
        invite = Invite.find_by_email(resource.email)
        redirect_to invite_path(invite, token: invite.token, errors: resource.errors.details)
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    end

  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :email, :password, :password_confirmation])
  end

  def after_sign_up_path_for(resource)
    game_competitions_path(Game.find_by_name("Magic: the Gathering"))
  end
end
