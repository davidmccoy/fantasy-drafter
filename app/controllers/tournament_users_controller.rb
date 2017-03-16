class TournamentUsersController < ApplicationController

  load_and_authorize_resource
  # sets @competition for all actions
  load_and_authorize_resource :tournament

  def index
  end

  def create

    user = User.find_by_email(params["email"])

    if user
      new_competitor = @tournament.tournament_users.where(user_id: user.id).first_or_create
      if new_competitor.save
        flash[:notice] = "Successfully added #{user.name} to the tournament."
      else
        flash[:alert] = "Couldn't add #{user.name} to the tournament."
      end
    else
      flash[:alert] = "Couldn't find a user with that email."
    end

    redirect_to game_competition_tournament_tournament_users_path(@tournament.competition.game,@tournament.competition, @tournament)

  end

  def destroy
    tournament_user = TournamentUser.find(params[:id])

    if tournament_user
      if tournament_user.user == @tournament.admin
        flash[:alert] = "You can't remove the admin of the tournament."
      else
        if tournament_user.destroy
          flash[:notice] = "Successfully removed #{tournament_user.user.name} from the tournament."
        else
          flash[:alert] = "Something went wrong. Couldn't remove #{tournament_user.user.name} from the tournament."
        end
      end
    else
      flash[:alert] = "Couldn't find that competitor in this tournament."
    end

    redirect_to game_competition_tournament_tournament_users_path(@tournament.competition.game,@tournament.competition, @tournament)

  end

end
