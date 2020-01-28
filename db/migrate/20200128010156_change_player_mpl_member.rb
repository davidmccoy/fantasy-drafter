class ChangePlayerMplMember < ActiveRecord::Migration[5.1]
  def change
    remove_column :players, :mpl_member
  end
end
