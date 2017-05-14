class ReplaceResultsIndex < ActiveRecord::Migration[5.0]
  def change
    remove_index :results, :player_id
    add_index :results, :player_id
  end
end
