class ChangeLeagueUsersTournamentId < ActiveRecord::Migration[5.0]
  def change
    rename_column :league_users, :tournament_id, :league_id
  end
end
