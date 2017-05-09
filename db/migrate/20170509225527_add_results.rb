class AddResults < ActiveRecord::Migration[5.0]
  def change
    create_table :results do |t|
      t.integer :player_id
      t.integer :competition_id
      t.integer :game_id
      t.integer :points

      t.timestamps null: false
    end

    add_index :results, :player_id, unique: true
  end
end
