class LeagueMailer < ApplicationMailer
  default from: 'commissioner@fantasypt.com'

  def invite_accepted league, user
    @league = league
    @league_admin = league.admin
    @user = user
    @url = Rails.application.routes.url_helpers.game_competition_league_url(
        game_id: @league.leagueable.game.id,
        competition_id: @league.leagueable.id,
        id: @league.id
      )

    mail(to: @league_admin.email, subject: "#{@user.name} has accepted their invite to your #{@league.leagueable.name} Fantasy Draft!")
  end

  def invite_declined league, user
    @league = league
    @league_admin = league.admin
    @user = user
    @url = Rails.application.routes.url_helpers.game_competition_league_url(
        game_id: @league.leagueable.game.id,
        competition_id: @league.leagueable.id,
        id: @league.id
      )

    mail(to: @league_admin.email, subject: "#{@user.name} has declined their invite to your #{@league.leagueable.name} Fantasy Draft.")
  end
end
