class ChangeCompetitionsDateToStartDate < ActiveRecord::Migration[5.1]
  def change
    rename_column :competitions, :date, :start_date
  end
end
