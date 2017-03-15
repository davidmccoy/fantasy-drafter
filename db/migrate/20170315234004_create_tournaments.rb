class CreateTournaments < ActiveRecord::Migration[5.0]
  def change
    create_table :tournaments do |t|
      t.integer :competition_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
