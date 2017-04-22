class LeagueUsersController < ApplicationController

  include ActionView::Helpers::UrlHelper

  load_and_authorize_resource
  # sets @competition for all actions
  load_and_authorize_resource :league

  def index
  end

  def create

    user = User.find_by_email(params["email"])

    if user
      new_competitor = @league.league_users.create(user_id: user.id)
      if new_competitor.save
        new_competitor.create_team(name: "#{new_competitor.user.name}'s Team")
        InviteMailer.existing_user(new_competitor).deliver_later
        flash[:notice] = "Successfully added #{user.name} to the league."
      else
        flash[:alert] = "Couldn't add #{user.name} to the league."
      end
    else
      flash[:alert] = "Couldn't find a Fantasy Pro Tour user with the email of #{params[:email]}. Click #{link_to("Here", Rails.application.routes.url_helpers.invites_url(email: params[:email], league_id: @league, inviting_user_id: current_user.id), method: :post)} to invite them anyway."
      flash[:html_safe] = true

      # redirect_to game_competition_league_league_users_path(@league.leagueable.game,@league.leagueable, @league), notice: %Q[Your artwork has been added to your portfolio. Upload a new piece <a href="#{upload_path(@user)}">here.</a>], flash: { html_safe: true }
    end

    redirect_to game_competition_league_league_users_path(@league.leagueable.game,@league.leagueable, @league)

  end

  # TODO notification email for accpted invite
  def update
    if @league_user.update(confirmed: true)
      flash[:notice] = "Welcome to #{@league_user.league.admin.name}'s #{@league_user.league.leagueable.name} Fantasy League!"
      redirect_to game_competition_league_league_users_path(@league.leagueable.game,@league.leagueable, @league)
    else
      flash[:alert] = "Something went wrong. Couldn't accept your invitiation to  #{@league_user.league.admin.name}'s #{@league_user.league.leagueable.name} Fantasy League."
      redirect_to game_competition_league_league_user_confirm_url(@league.leagueable.game,@league.leagueable, @league, @league_user)
    end
  end

  # TODO notification email for declined invite
  def destroy
    league_user = LeagueUser.find(params[:id])

    if league_user
      if league_user.user == @league.admin
        flash[:alert] = "You can't remove the admin of the league."
      elsif league_user.user == current_user
        if league_user.destroy
          flash[:notice] = "Successfully declined your invitation to #{league_user.league.admin.name}'s #{league_user.league.leagueable.name} Fantasy League."
          redirect_to root
        else
          flash[:alert] = "Something went wrong. Couldn't remove you from  #{league_user.league.admin.name}'s #{league_user.league.leagueable.name} Fantasy League."
          redirect_to game_competition_league_league_user_confirm_url(@league.leagueable.game,@league.leagueable, @league, league_user)
        end

      else
        if league_user.destroy
          flash[:notice] = "Successfully removed #{league_user.user.name} from the league."
        else
          flash[:alert] = "Something went wrong. Couldn't remove #{league_user.user.name} from the league."
        end
      end
    else
      flash[:alert] = "Couldn't find that competitor in this league."
    end

    redirect_to game_competition_league_league_users_path(@league.leagueable.game,@league.leagueable, @league)

  end

  def confirm
    @league_user = LeagueUser.find(params[:league_user_id])
  end

end
