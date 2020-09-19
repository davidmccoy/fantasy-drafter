namespace :standings do
  desc 'create 2020 season and assign competition(s) to it'
  task create_2020_season: :environment do
    game = Game.find_by_name('Magic: the Gathering')
    season = Season.create(
      game_id: game.id,
      name: '2020 Partial Season',
      slug: '2020',
      start_date: '2020-01-01',
      end_date: '2020-07-31',
      about: 'Starting in August 2020, Magic: the Gathering’s Organized Play calendar will be moving away from seasons that follow the calendar year (the 2019 season) back to seasons that are split over multiple calendar years (the 2020-2021 season). But the 2019 season ends in December 2019, so in order to fill the gap between then and the beginning of the 2020-2021 season, the Magic Pro League will hold a shortened seven-month season.',
    )

    competition = Competition.find_by_name('Players Tour Series 1')
    competition.update(season_id: season.id)
  end
end
