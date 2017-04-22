class AddEmailToInvites < ActiveRecord::Migration[5.0]
  def change
    add_column :invites, :email, :string
  end
end
