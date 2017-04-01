class Draft < ApplicationRecord

  belongs_to :tournament
  has_many :picks


  def create_picks
    pick_order = self.tournament.users.shuffle

    pick_number = 1
    # Create picks in snake order
    6.times do
      pick_order.each do |player|
        self.picks.create(
          user_id: player.id,
          number: pick_number
        )
        pick_number += 1
      end
      pick_order.reverse.each do |player|
        self.picks.create(
          user_id: player.id,
          number: pick_number
        )
        pick_number += 1
      end
    end

  end
end
