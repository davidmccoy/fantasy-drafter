class AddPickTypeToLeagues < ActiveRecord::Migration[5.1]
  def change
  	add_column :leagues, :pick_type, :integer, default: 0
  end
end
