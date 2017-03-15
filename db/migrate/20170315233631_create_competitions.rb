class CreateCompetitions < ActiveRecord::Migration[5.0]
  def change
    create_table :competitions do |t|
      t.integer :game_id
      t.string :name
      t.datetime :date
      t.string :location

      t.timestamps null: false
    end
  end
end
