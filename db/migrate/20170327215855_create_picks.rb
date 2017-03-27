class CreatePicks < ActiveRecord::Migration[5.0]
  def change
    create_table :picks do |t|
      t.integer :draft_id
      t.integer :user_id
      t.integer :player_id
      t.integer :number

      t.timestamps null: false
    end
  end
end
