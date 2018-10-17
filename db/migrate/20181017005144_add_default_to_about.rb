class AddDefaultToAbout < ActiveRecord::Migration[5.1]
  def change
    change_column :competitions, :about, :text, default: ''
  end
end
