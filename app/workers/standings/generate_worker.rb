module Standings
  class GenerateWorker
    include Sidekiq::Worker

    def perform(season_id)
      season = ::Season.find_by_id(season_id)
      season.players.find_each do |player|
        Standings::GeneratePointsWorker.perform_async(season.id, player.id)
      end
    end
  end
end
