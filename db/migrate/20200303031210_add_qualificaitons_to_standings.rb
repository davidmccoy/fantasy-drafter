class AddQualificaitonsToStandings < ActiveRecord::Migration[5.1]
  def change
    add_column :standings, :qualifies_for, :string
    add_column :standings, :qualifies_via, :string
  end
end
