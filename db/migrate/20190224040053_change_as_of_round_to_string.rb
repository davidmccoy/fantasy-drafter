class ChangeAsOfRoundToString < ActiveRecord::Migration[5.1]
  def change
    change_column :competitions, :score_as_of_round, :string
  end
end
