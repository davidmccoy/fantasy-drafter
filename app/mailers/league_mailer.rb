class LeagueMailer < ApplicationMailer
  default from: 'commissioner@fantasypt.com'

  def invite(league_user)
    @user = league_user.user
    @league = league_user.league
    @competition = @league.leagueable
    @game = @competition.game
    @url = Rails.application.routes.url_helpers.game_competition_league_draft_league_user_confirm_url(game_id: @game.id, competition_id: @competition.id, league_id: @league.id, id: league_user.id )

    mail(to: @user.email, subject: "You've Been Invited To Join #{@league.admin.name}'s #{@competition.name} Fantasy Draft!")
  end
end
