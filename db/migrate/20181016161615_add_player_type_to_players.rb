class AddPlayerTypeToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :player_type, :integer, default: 0
  end
end
