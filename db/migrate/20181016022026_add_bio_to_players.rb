class AddBioToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :bio, :text
  end
end
