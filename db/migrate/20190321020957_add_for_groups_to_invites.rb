class AddForGroupsToInvites < ActiveRecord::Migration[5.1]
  def change
    add_column :invites, :for_group, :boolean, default: false
  end
end
