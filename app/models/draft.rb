class Draft < ApplicationRecord

  belongs_to :league
  has_many :picks
  has_many :users, through: :leagues
  has_many :teams, through: :leagues

  # find completed drafts per competition:
  # Draft.joins("LEFT JOIN leagues ON leagues.id = drafts.league_id").joins("LEFT JOIN competitions ON competitions.id = leagues.leagueable_id").where(drafts: {completed: true}, competitions: {id: 7})


  def create_picks
    pick_order = self.league.users.shuffle

    pick_number = 1
    # Create picks in snake order
    self.league.num_draft_rounds.times do |i|
      if i % 2 == 0
        pick_order.each do |user|
          self.picks.create(
            team_id: user.team(self.league).id,
            number: pick_number
          )
          pick_number += 1
        end
      else
        pick_order.reverse.each do |user|
          self.picks.create(
            team_id: user.team(self.league).id,
            number: pick_number
          )
          pick_number += 1
        end
      end
    end

  end
end
