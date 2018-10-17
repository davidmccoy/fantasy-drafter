class AddAboutToSeasons < ActiveRecord::Migration[5.1]
  def change
    add_column :seasons, :about, :text, default: ''
  end
end
