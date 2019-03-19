class CreateCharacterCompetitions < ActiveRecord::Migration[5.1]
  def change
    create_table :character_competitions do |t|
      t.integer :character_id
      t.integer :competition_id
      t.bigint  :seed
      t.string  :group
    end
  end
end
