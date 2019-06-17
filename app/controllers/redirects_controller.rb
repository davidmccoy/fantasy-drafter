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

  def mythic_invitational
    competition = Competition.find_by_name('Mythic Invitational')
    if competition
      redirect_to game_competition_leagues_path(competition.game, competition) and return
    else
      redirect_to root_path and return
    end
  end

  def mythic_championship
    competition = Competition.find_by_name('Mythic Championship III Las Vegas')
    if competition
      redirect_to game_competition_leagues_path(competition.game, competition) and return
    else
      redirect_to root_path and return
    end
  end
end
