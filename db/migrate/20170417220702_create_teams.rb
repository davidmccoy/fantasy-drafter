class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.integer :user_id
      t.integer :league_id

      t.timestamps null: false
    end
  end
end
