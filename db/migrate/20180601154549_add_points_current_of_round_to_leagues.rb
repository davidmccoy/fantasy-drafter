class AddPointsCurrentOfRoundToLeagues < ActiveRecord::Migration[5.1]
  def change
    add_column :competitions, :score_as_of_round, :integer, default: 0
  end
end
