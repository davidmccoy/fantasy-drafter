class AddPlaceToStandings < ActiveRecord::Migration[5.1]
  def change
    add_column :standings, :place, :integer
    add_column :standings, :winnings, :numeric
  end
end
