class AddSubmittedToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :submitted, :boolean, default: false
  end
end
