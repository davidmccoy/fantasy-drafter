class AddEloT25PowerRankings < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :elo, :integer
    add_column :players, :top_25_ranking, :integer
    add_column :players, :power_ranking, :integer
  end
end
