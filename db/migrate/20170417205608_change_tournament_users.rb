class ChangeTournamentUsers < ActiveRecord::Migration[5.0]
  def change
    rename_table :tournament_users, :league_users
  end
end
