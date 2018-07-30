class AddDraftRoundsToLeague < ActiveRecord::Migration[5.1]
  def change
    add_column :leagues, :num_draft_rounds, :integer, default: 6
  end
end
