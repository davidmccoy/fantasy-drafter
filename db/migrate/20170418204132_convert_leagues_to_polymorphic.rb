class ConvertLeaguesToPolymorphic < ActiveRecord::Migration[5.0]
  def change
    rename_column :leagues, :competition_id, :leagueable_id
    add_column :leagues, :leagueable_type, :string

    add_index :leagues, [:leagueable_type, :leagueable_id]
  end
end
