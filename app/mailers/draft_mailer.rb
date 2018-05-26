class DraftMailer < ApplicationMailer
  default from: 'commissioner@fantasypt.com'

  def draft_finished draft
    @draft = draft
    @league = draft.league
    @league_user_emails = @league.league_users.includes(:user).pluck(:email)
    @url = Rails.application.routes.url_helpers.game_competition_league_url(
        game_id: @league.leagueable.game.id,
        competition_id: @league.leagueable.id,
        id: @league.id
      )

    mail(to: @league_user_emails, subject: "Congrats! You finished your Fantasy Draft for #{@league.leagueable.name}!")
  end
end