class CreateMatches < ActiveRecord::Migration[5.1]
  def change
    create_table :matches do |t|
      t.integer :competition_id
      t.integer :player_a_id
      t.integer :player_b_id
      t.integer :winner_id
      t.string  :arcanis_id
      t.string  :arcanis_event_id
      t.string  :arcanis_player_a_id
      t.string  :arcanis_player_b_id
      t.string  :result
    end

    add_index :matches, :arcanis_id
    add_index :matches, :competition_id
    add_index :matches, :player_a_id
    add_index :matches, :player_b_id
  end
end
