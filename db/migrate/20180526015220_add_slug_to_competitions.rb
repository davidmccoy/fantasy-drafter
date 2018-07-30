class AddSlugToCompetitions < ActiveRecord::Migration[5.1]
  def change
    add_column :competitions, :slug, :string
    add_index :competitions, :slug, unique: true
  end
end
