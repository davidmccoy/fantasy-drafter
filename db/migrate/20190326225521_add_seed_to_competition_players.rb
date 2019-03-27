class AddSeedToCompetitionPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :competition_players, :seed, :integer
  end
end
