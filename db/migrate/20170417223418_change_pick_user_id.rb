class ChangePickUserId < ActiveRecord::Migration[5.0]
  def change
    rename_column :picks, :user_id, :team_id
  end
end
