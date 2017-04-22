class AddDefaultToInviteAccepted < ActiveRecord::Migration[5.0]
  def change
    change_table :invites do |t|
      t.change :accepted, :boolean, default: false
    end
  end
end
