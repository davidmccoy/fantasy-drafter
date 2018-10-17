class AddAboutToCompetitions < ActiveRecord::Migration[5.1]
  def change
    add_column :competitions, :about, :text
  end
end
