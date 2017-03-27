class AddActiveCompletedToDrafts < ActiveRecord::Migration[5.0]
  def change
    change_table :drafts do |t|
      t.boolean :active, null: false, default: false
      t.boolean :completed, null: false, default: false
    end
  end
end
