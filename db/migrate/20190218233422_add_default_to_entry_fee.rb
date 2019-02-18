class AddDefaultToEntryFee < ActiveRecord::Migration[5.1]
  def change
    change_column :leagues, :entry_fee, :bigint, default: nil
  end
end
