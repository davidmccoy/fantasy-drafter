class AddMtgArenaHandleToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :mtg_arena_handle, :string
  end
end
