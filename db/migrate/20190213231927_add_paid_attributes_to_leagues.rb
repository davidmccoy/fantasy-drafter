class AddPaidAttributesToLeagues < ActiveRecord::Migration[5.1]
  def change
    add_column :leagues, :paid_entry, :boolean, default: false
    add_column :leagues, :entry_fee, :bigint, default: 0
  end
end
