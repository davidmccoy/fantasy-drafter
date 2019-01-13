class AddArcanisIdsToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :arcanis_id, :string
    add_column :competitions, :arcanis_id, :string

    add_index :players, :arcanis_id
    add_index :competitions, :arcanis_id
  end
end
