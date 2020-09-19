class Standing < ApplicationRecord
  belongs_to :season
  belongs_to :player

  before_commit :set_tiebreakers_default, on: [:create]

  def to_param
    slug
  end

  # this should be a presenter
  def status(league)
    qualification[league]
  end

  private

  def qualification
    {
      '2020-21 Magic Pro League' => 'success',
      '2020 MPL Gauntlet' => 'warning',
      '2020-21 Magic Rivals League' => 'danger'
    }
  end

  def set_tiebreakers_default
    self.tiebreakers = {
      mpl: nil,
      rivals_mythic_points: nil,
      rivals_player_points: nil,
    }
  end
end
