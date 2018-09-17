class AddPublicAndDraftTypeToLeagues < ActiveRecord::Migration[5.1]
  def change
    add_column :leagues, :public, :boolean, default: false
    add_column :leagues, :draft_type, :integer
  end
end
