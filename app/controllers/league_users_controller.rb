class LeagueUsersController < ApplicationController

  load_and_authorize_resource
  # sets @competition for all actions
  load_and_authorize_resource :league

  def index
  end

  def create

    user = User.find_by_email(params["email"])

    if user
      new_competitor = @league.league_users.where(user_id: user.id).first_or_create
      if new_competitor.save
        flash[:notice] = "Successfully added #{user.name} to the league."
      else
        flash[:alert] = "Couldn't add #{user.name} to the league."
      end
    else
      flash[:alert] = "Couldn't find a user with that email."
    end

    redirect_to game_competition_league_league_users_path(@league.competition.game,@league.competition, @league)

  end

  def destroy
    league_user = LeagueUser.find(params[:id])

    if league_user
      if league_user.user == @league.admin
        flash[:alert] = "You can't remove the admin of the league."
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

    redirect_to game_competition_league_league_users_path(@league.competition.game,@league.competition, @league)

  end

end
