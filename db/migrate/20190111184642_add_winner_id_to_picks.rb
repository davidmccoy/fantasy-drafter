class AddWinnerIdToPicks < ActiveRecord::Migration[5.1]
  def change
    add_column :picks, :winner_id, :integer
  end
end
