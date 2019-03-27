class AddPlayerTypeToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :player_type, :string
    add_column :matches, :bracket_section, :integer
  end
end
