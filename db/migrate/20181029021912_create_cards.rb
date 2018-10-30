class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
    	t.integer :scryfall_id
	  	t.integer :oracle_id
	  	t.string :name
	  	t.string :image_uri
	  	t.string :mana_cost
	  	t.string :cmc
	  	t.string :type_line
	  	t.string :oracle_text
	    t.string :power
	    t.string :toughness
	    t.string :loyalty
	    t.string :colors, array: true, default: []
	    t.jsonb :legalities, null: false, default: '{}'
	  	t.string :rarity
	  	t.string :flavor_text
	  	t.string :artist
	  	t.string :frame
    end

    add_index  :cards, :colors, using: :gin
    add_index  :cards, :legalities, using: :gin
  end
end
