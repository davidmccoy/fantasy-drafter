class ConvertPicksToPolymorphic < ActiveRecord::Migration[5.1]
  def change
  	add_column :picks, :pickable_type, :string, default: 'Player'
  	rename_column :picks, :player_id, :pickable_id
  end
end
