class AddStatsUpdatedAtToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :stats_updated_at, :datetime
    add_column :players, :gp_record, :string
    add_column :players, :pt_record, :string
    add_column :players, :stats_url, :string
  end
end
