class CreateInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :invites do |t|
      t.string :token
      t.integer :league_id
      t.integer :inviting_user_id
      t.integer :invited_user_id
      t.boolean :accepted

      t.timestamps null: false
    end

    add_index :invites, :token, unique: true
  end
end
