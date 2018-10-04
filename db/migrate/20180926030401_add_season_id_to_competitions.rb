class AddSeasonIdToCompetitions < ActiveRecord::Migration[5.1]
  def change
    add_column :competitions, :season_id, :integer
  end
end
