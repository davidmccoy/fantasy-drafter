class AddRankPointsToResults < ActiveRecord::Migration[5.1]
  def change
    add_column :results, :rank_points, :integer, default: 0
    add_column :results, :rank_points_type, :string
    add_column :results, :winnings, :numeric
  end
end
