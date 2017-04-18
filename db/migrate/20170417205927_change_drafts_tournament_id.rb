class ChangeDraftsTournamentId < ActiveRecord::Migration[5.0]
  def change
    rename_column :drafts, :tournament_id, :league_id
  end
end
