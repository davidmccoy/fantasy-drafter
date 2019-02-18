class AddPrizePayoutsToLeagues < ActiveRecord::Migration[5.1]
  def change
    add_column :leagues, :prize_payouts, :text
    add_column :leagues, :description, :text
  end
end
