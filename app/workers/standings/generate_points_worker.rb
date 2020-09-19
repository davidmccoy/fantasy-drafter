module Standings
  class GeneratePointsWorker
    include Sidekiq::Worker

    def perform(season_id, player_id)
      @season = ::Season.find(season_id)
      player = ::Player.find(player_id)

      Standings::Season.generate_points(@season, player)

      Standings::GenerateRanksWorker.perform_async(@season.id) if generate_season_ranks?
    end

    # only generate the season ranks if all players in the season have been
    # assigned points
    def generate_season_ranks?
      @season.standings.count == @season.players.count
    end
  end
end
