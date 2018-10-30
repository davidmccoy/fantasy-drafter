class ConvertStarsIntoPolymorphic < ActiveRecord::Migration[5.1]
  def change
  	add_column :stars, :starrable_type, :string, default: 'Player'
  	rename_column :stars, :player_id, :starrable_id
  end
end
