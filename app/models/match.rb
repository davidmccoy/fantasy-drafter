class Match < ApplicationRecord
  belongs_to :competition
  # belongs_to :player_a,
  #            class_name: 'Player',
  #            foreign_key: 'player_a_id',
  #            optional: true
  # belongs_to :player_b,
  #            class_name: 'Player',
  #            foreign_key: 'player_b_id',
  #            optional: true
  belongs_to :player_a_previous_match,
             class_name: 'Match',
             foreign_key: 'player_a_previous_match_id',
             optional: true
  belongs_to :player_b_previous_match,
             class_name: 'Match',
             foreign_key: 'player_b_previous_match_id',
             optional: true
  has_many   :picks, as: :pickable

  enum       bracket_section: { winners: 0, losers: 1 }

  def players
    Player.where(id: [player_a, player_b])
  end

  # custom polymorphic relationship since we have two columns (player_a_id
  # and player_b_id) that are polymorphic but are always the same class
  def player_a
    player_type.constantize.find_by_id(player_a_id)
  end

  def player_b
    player_type.constantize.find_by_id(player_b_id)
  end
end
