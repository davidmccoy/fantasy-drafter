class CreateCardCompetitions < ActiveRecord::Migration[5.1]
  def change
    create_table :card_competitions do |t|
    	t.integer :card_id
    	t.integer :competition_id
    	t.integer :percent_of_decks
    	t.float 	:number_of_copies
    	t.integer :xrank
    end

    add_index :card_competitions, :card_id
    add_index :card_competitions, :competition_id
  end
end
