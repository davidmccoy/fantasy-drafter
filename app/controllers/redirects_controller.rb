class RedirectsController < ApplicationController
  def sparkmadness
    competition = Competition.find_by_name('Spark Madness')
    league = League.find_by(
      leagueable_id: competition.id,
      leagueable_type: 'Competition',
      public: true
    )
    if competition
      redirect_to game_competition_league_path(competition.game, competition, league) and return
    else
      redirect_to root_path and return
    end
  end
end
