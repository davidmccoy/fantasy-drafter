class AddDefaultToTeamPoints < ActiveRecord::Migration[5.1]
  def change
    change_column :teams, :points, :bigint, default: 0
  end
end
