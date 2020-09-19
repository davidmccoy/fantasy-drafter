class LeagueCalculateTeamPointsWorker
  include Sidekiq::Worker

  def perform(league_id, pick_type, leagueable_type)
    league = League.find_by_id(league_id)

    league.teams.find_each do |team|
      team.calculate_points(pick_type)
    end
  end
end
