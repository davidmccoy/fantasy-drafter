class AddAcceptedToLeagueUsersTable < ActiveRecord::Migration[5.0]
  def change
    change_table :league_users do |t|
      t.boolean :confirmed, null: false, default: false
    end
  end
end
