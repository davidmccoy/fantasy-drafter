namespace :players do
  desc 'combine both kvarteks'
  task combine_kvarteks: :environment do
    id_to_keep = 1184
    id_to_combine = 1678

    CompetitionPlayer.where(player_id: id_to_combine).each do |cp|
      cp.update(player_id: id_to_keep)
    end

    Result.where(resultable_type: 'Player', resultable_id: id_to_combine).each do |result|
      result.update(resultable_id: id_to_keep)
    end
  end
end
