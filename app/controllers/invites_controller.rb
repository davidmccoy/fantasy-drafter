class InvitesController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_invite

  def show
    if @invite.token == params[:token]
      if current_user && @invite.for_group
        # TODO: include check for existing individual invite to the league
        # TODO: this is repeated in the league users controller
        unless current_user.leagues.include? @invite.league
          @league = @invite.league
          league_user = nil
          team = nil
          LeagueUser.transaction do
            Team.transaction do
              # create league user
              league_user = LeagueUser.create!(
                league_id: @league.id,
                user_id: current_user.id,
                confirmed: true
              )
              # create team
              team = league_user.create_team(name: "Team #{@invite.league.teams.count + 1} (#{league_user.user.name})")
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
              elsif @league.draft_type == 'bracket'
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

          if league_user && team
            # TODO: make it work with seasonal leagues
            flash[:notice] = "You've joined #{@invite.league.name}!"
            redirect_to game_competition_league_path(@invite.league.leagueable.game, @invite.league.leagueable, @invite.league) and return
          end
        end
      end

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
    leagueable_class = league.leagueable.class


    # TODO fails because Invites use User ids rather than email
    if invite.save
      flash[:notice] = "Invite sent to #{params[:email]}."
    else
      flash[:alert] = "Invite to #{params[:email]} failed to send."
    end

    if leagueable_class == Season
      redirect_to game_season_league_league_users_path(league.leagueable.game, league.leagueable, league) and return
    elsif leagueable_class == Competition
      redirect_to game_competition_league_league_users_path(league.leagueable.game, league.leagueable, league) and return
    end
  end

  def resend

  end

  private

  def invite_params
    params.permit(:email, :league_id)
  end

end
