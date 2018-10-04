class CreatePlayerRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :player_records do |t|
      t.integer :player_id
      t.string :competition_name
      t.string :competition_record
      t.string :competition_format
    end
  end
end
