class InviteMailer < ApplicationMailer
  default from: 'commissioner@fantasypt.com'

  def new_user(invite)
    @league = invite.league
    @competition = @league.leagueable
    @game = @competition.game
    @url = Rails.application.routes.url_helpers.invite_url(invite, token: invite.token)

    mail(to: invite.email, subject: "You've Been Invited To Join #{@league.admin.name}'s #{@competition.name} Fantasy Draft!")
  end

  def existing_user(league_user)
    @user = league_user.user
    @league = league_user.league
    @competition = @league.leagueable
    @game = @competition.game
    @url = Rails.application.routes.url_helpers.game_competition_league_league_user_confirm_url(game_id: @game.id, competition_id: @competition.id, league_id: @league.id, league_user_id: league_user.id )

    mail(to: @user.email, subject: "You've Been Invited To Join #{@league.admin.name}'s #{@competition.name} Fantasy Draft!")
  end
end
