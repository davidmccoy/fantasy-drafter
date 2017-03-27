class CreateCompetitionPlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :competition_players do |t|
      t.integer :competition_id
      t.integer :player_id 
    end
  end
end
