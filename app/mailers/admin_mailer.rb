class AdminMailer < ApplicationMailer
  default from: 'commissioner@fantasypt.com'

  def new_user user, email
    @user = user

    mail(to: email, subject: "Fantasy Pro Tour: New User")
  end

  def new_league league, email
    @league = league
    @url = Rails.application.routes.url_helpers.game_competition_league_url(
        game_slug: @league.leagueable.game.slug,
        competition_slug: @league.leagueable.slug,
        id: @league.id
      )

    mail(to: email, subject: "Fantasy Pro Tour: New League!")
  end
end
