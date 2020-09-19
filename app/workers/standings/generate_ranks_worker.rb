module Standings
  class GenerateRanksWorker
    include Sidekiq::Worker

    def perform(season_id)
      season = ::Season.find(season_id)

      Standings::Season.generate_ranks(season)
    end
  end
end
