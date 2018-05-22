class AddPlaceToResults < ActiveRecord::Migration[5.1]
  def change
    add_column :results, :place, :integer
  end
end
