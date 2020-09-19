namespace :competitions do
  desc 'create Feb 2020 mythic point challenge data'
  task create_february_2020_mythic_point_challenge: :environment do
    game = Game.find_by_name 'Magic: the Gathering'
    season = Season.find_by_name '2020 Partial Season'
    competition = Competition.create(
      game_id: game.id,
      name: 'Mythic Point Challenge Ikoria #1',
      start_date: '2020-02-29 15:00:00',
      end_date: '2020-02-29',
      location: 'MTG Arena',
      slug: 'mpcikoria1',
      season_id: season.id,
    )

    players = {
      "Brad Nelson" => 6,
      "Brian Braun-Duin" => 6,
      "Christpoher Kvartek" => 6,
      "Ken Yukuhiro" => 6,
      "Marcio Carvalho" => 6,
      "Andrew Cuneo" => 5,
      "Raphael Levy" => 5,
      "Piotr Glogowski" => 4,
      "Shahar Shenhar" => 4,
      "Ondrej Strasky" => 3,
      "Jean-Emmanuel Depraz" => 2,
      "Reid Duke" => 1,
      "Seth Manfield" => 1,
      "Matthew Nass" => 6,
      "Greg Orange" => 6,
      "Luis Scott-Vargas" => 6,
      "Stanislav Cifka" => 6,
      "Emma Handy" => 5,
      "Eli Kassis" => 4,
      "Eli Loveman" => 4,
      "Thoralf Severin" => 3,
      "Alexander Hayne" => 3,
      "No Ah Ma" => 3,
      "Bernardo Santos" => 2,
      "Luis Salvatto" => 1,
      "Mike Sigrist" => 2,
      "Yoshihiko Ikawa" => 2,
      "Ben Stark" => 1,
      "Grzegorz Kowalski" => 1,
      "Matias Leveratto" => 1,
    }

    season.players.each do |player|
      result = Result.where(
        game_id: game.id,
        competition_id: competition.id,
        resultable_id: player.id,
        resultable_type: 'Player',
        rank_points_type: 'Mythic Points'
      ).first_or_create

      rank_points = players[player.name]
      result.update(
        points: rank_points ? (rank_points + 4) * 3 : 0,
        rank_points: rank_points ? rank_points : 0,
        place: nil,
      )
    end
  end

  desc 'create ikoria mythic qualifier 1 data'
  task create_ikoria_mythic_qualifier_1: :environment do
    game = Game.find_by_name 'Magic: the Gathering'
    season = Season.find_by_name '2020 Partial Season'
    competition = Competition.create(
      game_id: game.id,
      name: 'Ikoria Mythic Qualifier #1',
      start_date: '2020-01-11 15:00:00',
      end_date: '2020-01-11',
      location: 'MTG Arena',
      slug: 'ikoriamq1',
      season_id: season.id,
    )

    players = {
      "Ally Warfield" => 1,
      "John Rolf" => 1,
      "Luis Salvatto" => 1,
      "Matthew Nass" => 6,
      "Matthew Sperling" => 2,
      "Thoralf Severin" => 1,
    }

    season.players.each do |player|
      result = Result.where(
        game_id: game.id,
        competition_id: competition.id,
        resultable_id: player.id,
        resultable_type: 'Player',
        rank_points_type: 'Mythic Points'
      ).first_or_create

      rank_points = players[player.name]
      result.update(
        points: rank_points ? (rank_points + 4) * 3 : 0,
        rank_points: rank_points ? rank_points : 0,
        place: nil,
      )
    end
  end
end
