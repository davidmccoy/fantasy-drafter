class ConvertResultsToPolymorphic < ActiveRecord::Migration[5.1]
  def change
  	add_column :results, :resultable_type, :string, default: 'Player'
  	rename_column :results, :player_id, :resultable_id
  end
end
