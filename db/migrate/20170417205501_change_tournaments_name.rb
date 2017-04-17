class ChangeTournamentsName < ActiveRecord::Migration[5.0]
  def change
     rename_table :tournaments, :leagues
  end
end
