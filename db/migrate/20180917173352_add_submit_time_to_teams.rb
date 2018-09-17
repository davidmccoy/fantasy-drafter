class AddSubmitTimeToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :submitted_at, :datetime
  end
end
