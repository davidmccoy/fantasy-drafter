class PickMailer < ApplicationMailer
  default from: 'commissioner@fantasypt.com'

  def next_pick(pick)
    @pick = pick
    @user = @pick.user
    @draft = @pick.draft
    @tournament = @draft.tournament
    @competition = @tournament.competition
    @game = @competition.game
    @url = Rails.application.routes.url_helpers.game_competition_tournament_draft_url(game_id: @game.id, competition_id: @competition.id, tournament_id: @tournament.id, id: @draft.id )

    mail(to: @user.email, subject: "It's Your Pick! Make Your Selection For Your #{@competition.name} Fantasy Draft!")
  end
end
