class PickMailer < ApplicationMailer
  default from: 'commissioner@fantasypt.com'

  def next_pick(pick)
    @pick = pick
    @user = @pick.user
    @draft = @pick.draft
    @league = @draft.league
    @competition = @league.leagueable
    @game = @competition.game
    @url = Rails.application.routes.url_helpers.game_competition_league_draft_url(game_slug: @game.slug, competition_slug: @competition.slug, league_id: @league.id, id: @draft.id )

    mail(to: @user.email, subject: "It's Your Pick! Make Your Selection For Your #{@competition.name} Fantasy Draft!")
  end
end
