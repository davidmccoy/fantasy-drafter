class AddLeagueToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :league, :string
    add_column :players, :country_image_url, :string
    add_column :players, :team_image_url, :string
  end
end
