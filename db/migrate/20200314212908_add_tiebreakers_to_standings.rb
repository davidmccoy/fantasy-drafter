class AddTiebreakersToStandings < ActiveRecord::Migration[5.1]
  def change
    add_column :standings, :tiebreakers, :jsonb, default: {}
  end
end
