class LeagueUsersController < ApplicationController

  include ActionView::Helpers::UrlHelper

  before_action :set_game
  before_action :set_competition
  before_action :set_league
  before_action :set_league_user
  before_action :authorize_league_user

  def index
  end

  def create
    league_user = nil
    team = nil
    if request.referrer.include? "join"
      LeagueUser.transaction do
        Team.transaction do
          # create league user
          league_user = LeagueUser.create!(
            league_id: @league.id,
            user_id: current_user.id,
            confirmed: true
          )
          # create team
          team = league_user.create_team(team_params)
          team.save!
          # create picks
          if @league.draft_type == 'pick_x'
            @league.num_draft_rounds.times {
              Pick.create(
                draft_id: @league.draft.id,
                team_id: team.id,
                pickable_type: @league.pick_type.classify
              )
            }
          elsif @league.draft_type == 'pick_em'
            @league.leagueable.matches.each do |match|
              Pick.create(
                draft_id: @league.draft.id,
                team_id: team.id,
                pickable_type: 'Match',
                pickable_id: match.id
              )
            end
          end
        end
      end
      if league_user
        flash[:notice] = "Successfully joined this league."
        redirect_to game_competition_league_path(@league.leagueable.game,@league.leagueable, @league) and return
      else
        flash[:alert] = "Failed to join this league."
        redirect_to game_competition_league_join_path(@league.leagueable.game,@league.leagueable, @league) and return
      end
    else
      user = User.find_by_email(params["email"]&.downcase)

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
        flash[:alert] = "Couldn't find a Thousand Leagues user with the email of #{params[:email]}. Click #{link_to("here", Rails.application.routes.url_helpers.invites_url(email: params[:email], league_id: @league.id), method: :post)} to invite them anyway."
        flash[:html_safe] = true

        # redirect_to game_competition_league_league_users_path(@league.leagueable.game,@league.leagueable, @league), notice: %Q[Your artwork has been added to your portfolio. Upload a new piece <a href="#{upload_path(@user)}">here.</a>], flash: { html_safe: true }
      end

      redirect_to game_competition_league_league_users_path(@league.leagueable.game,@league.leagueable, @league) and return
    end

  rescue StandardError, ActiveRecord::Invalid => e
    p e
    case e.record.class.name
    when 'LeagueUser'
      if e.record.errors.messages.include? :user_id
        flash[:alert] = 'You are already in this league.'
      else
        flash[:alert] = 'Something went wrong. Maybe you\'re already in this league?'
      end
    when 'Team'
      flash[:alert] = team.errors.messages
    else
      flash[:alert] = team.errors.messages
    end
    redirect_to game_competition_league_join_path(@league.leagueable.game,@league.leagueable, @league) and return
  end

  # TODO notification email for accpted invite
  def update
    if @league_user.update(confirmed: true)
      team = @league_user.team
      if @league.draft_type == 'pick_x'
        @league.num_draft_rounds.times {
          Pick.create(
            draft_id: @league.draft.id,
            team_id: team.id,
            pickable_type: @league.pick_type.classify
          )
        }
      elsif @league.draft_type == 'pick_em'
        @league.leagueable.matches.each do |match|
          Pick.create(
            draft_id: @league.draft.id,
            team_id: team.id,
            pickable_type: 'Match',
            pickable_id: match.id
          )
        end
      end
      if @league_user.user == current_user
        flash[:notice] = "Welcome to #{@league_user.league.admin.name}'s #{@league_user.league.leagueable.name} Fantasy League!"
        LeagueMailer.invite_accepted(@league, @league_user.user).deliver_later
      else
        flash[:notice] = "Confirmed #{@league_user.user.name} to #{@league_user.league.admin.name}'s #{@league_user.league.leagueable.name} Fantasy League."
      end
      redirect_to game_competition_league_path(@league.leagueable.game,@league.leagueable, @league)
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
        user = league_user.user
        if league_user.destroy
          flash[:notice] = "Successfully declined your invitation to #{league_user.league.admin.name}'s #{league_user.league.leagueable.name} Fantasy League."
          LeagueMailer.invite_declined(@league, user).deliver_later
          redirect_to root_path and return
        else
          flash[:alert] = "Something went wrong. Couldn't remove you from  #{league_user.league.admin.name}'s #{league_user.league.leagueable.name} Fantasy League."
          redirect_to game_competition_league_league_user_confirm_url(@league.leagueable.game,@league.leagueable, @league, league_user) and return
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

    redirect_to game_competition_league_league_users_path(@league.leagueable.game, @league.leagueable, @league) and return

  end

  def confirm
    @league_user = LeagueUser.find_by_id(params[:league_user_id])
    redirect_to game_competition_league_path(@game, @competition, @league) unless @league_user
  end

  def resend_invite
    @league_user = LeagueUser.find(params[:league_user_id])
    InviteMailer.existing_user(@league_user).deliver_later

    flash[:notice] = "Invite resent to #{@league_user.user.email}."

    redirect_to game_competition_league_league_users_path(@league_user.league.leagueable.game, @league_user.league.leagueable, @league_user.league)
  end

  private

  def team_params
    params.require(:team).permit(:name, :supporting)
  end

end
