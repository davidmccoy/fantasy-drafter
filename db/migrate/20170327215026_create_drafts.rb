class CreateDrafts < ActiveRecord::Migration[5.0]
  def change
    create_table :drafts do |t|
      t.integer :tournament_id
      t.datetime :start_time
      t.integer :rounds

      t.timestamps null: false
    end
  end
end
