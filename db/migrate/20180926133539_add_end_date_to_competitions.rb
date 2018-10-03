class AddEndDateToCompetitions < ActiveRecord::Migration[5.1]
  def change
    add_column :competitions, :end_date, :date
  end
end
