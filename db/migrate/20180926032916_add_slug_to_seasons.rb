class AddSlugToSeasons < ActiveRecord::Migration[5.1]
  def change
    add_column :seasons, :slug, :string
    add_index :seasons, :slug, unique: true
  end
end
