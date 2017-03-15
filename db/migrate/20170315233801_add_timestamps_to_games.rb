class AddTimestampsToGames < ActiveRecord::Migration[5.0]
  def change
    change_table :games do |t|
      t.timestamps null: false
    end
  end
end
