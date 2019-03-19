class AddFieldsToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :round,                      :integer
    add_column :matches, :group,                      :string
    add_column :matches, :bracket_position,           :integer
    add_column :matches, :player_a_previous_match_id, :integer
    add_column :matches, :player_b_previous_match_id, :integer
  end
end
