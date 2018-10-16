class AddSupportingToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :supporting, :string
  end
end
