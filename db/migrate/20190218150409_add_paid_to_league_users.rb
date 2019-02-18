class AddPaidToLeagueUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :league_users, :paid, :boolean, default: false
  end
end
