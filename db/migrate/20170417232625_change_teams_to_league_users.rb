class ChangeTeamsToLeagueUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :teams, :user_id, :league_user_id
    remove_column :teams, :league_id 
  end
end
