class RemoveUserIdsFromInvites < ActiveRecord::Migration[5.1]
  def change
    remove_column :invites, :inviting_user_id, :integer
    remove_column :invites, :invited_user_id, :integer
  end
end
