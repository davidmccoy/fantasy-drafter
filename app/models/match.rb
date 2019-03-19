class Match < ApplicationRecord
  belongs_to :competition
  belongs_to :player_a,
             class_name: 'Player',
             foreign_key: 'player_a_id',
             optional: true
  belongs_to :player_b,
             class_name: 'Player',
             foreign_key: 'player_b_id',
             optional: true
  belongs_to :player_a_previous_match,
             class_name: 'Match',
             foreign_key: 'player_a_previous_match_id',
             optional: true
  belongs_to :player_b_previous_match,
             class_name: 'Match',
             foreign_key: 'player_b_previous_match_id',
             optional: true
  has_many :picks, as: :pickable

  def players
    Player.where(id: [player_a, player_b])
  end
end
