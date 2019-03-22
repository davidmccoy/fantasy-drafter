class AddInvitationalFieldsToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :image_url, :text
    add_column :players, :twitter_handle, :string
    add_column :players, :bio_source, :text
    add_column :players, :mpl_member, :boolean, default: false

    add_column :competition_players, :group, :string
  end
end
