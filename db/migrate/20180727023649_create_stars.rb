class CreateStars < ActiveRecord::Migration[5.1]
  def change
    create_table :stars do |t|
      t.integer :draft_id
      t.integer :team_id
      t.integer :player_id
    end
  end
end
