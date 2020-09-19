class Standing < ActiveRecord::Migration[5.1]
  def change
    create_table :standings do |t|
      t.integer :season_id
      t.integer :player_id
      t.integer :mythic_points, default: 0
      t.integer :player_points, default: 0
      t.integer :total_points, default: 0
    end

    add_index :standings, :season_id
    add_index :standings, :player_id
  end
end
