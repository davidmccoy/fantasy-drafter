class InviteMailer < ApplicationMailer
  default from: 'commissioner@fantasypt.com'

  def new_user(invite)
    @league = invite.league
    @leagueable = @league.leagueable
    @game = @leagueable.game
    @url = Rails.application.routes.url_helpers.invite_url(invite, token: invite.token)

    mail(to: invite.email, subject: "You've Been Invited To Join #{@league.admin.name}'s #{@leagueable.name} Fantasy Draft!")
  end

  def existing_user(league_user)
    @user = league_user.user
    @league = league_user.league
    @leagueable = @league.leagueable
    @game = @leagueable.game
    leagueable_class = @leagueable.class
    if leagueable_class == Season
      @url =
        Rails.application.routes.url_helpers.game_season_league_league_user_confirm_url(
          game_slug: @game.slug,
          season_slug: @leagueable.slug,
          league_id: @league.id,
          league_user_id: league_user.id
        )
    elsif leagueable_class == Competition
      @url =
        Rails.application.routes.url_helpers.game_competition_league_league_user_confirm_url(
          game_slug: @game.slug,
          competition_slug: @leagueable.slug,
          league_id: @league.id,
          league_user_id: league_user.id
        )
    end

    mail(to: @user.email, subject: "You've Been Invited To Join #{@league.admin.name}'s #{@leagueable.name} Fantasy Draft!")
  end
end
