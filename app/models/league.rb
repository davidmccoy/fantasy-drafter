class League < ApplicationRecord

  belongs_to :leagueable, polymorphic: true
  has_many :league_users, dependent: :destroy
  has_many :users, through: :league_users
  belongs_to :admin, class_name: "User", foreign_key: "user_id"
  has_one :draft, dependent: :destroy
  has_many :teams, through: :league_users
  has_many :invites

  enum draft_type: { snake: 0, pick_x: 1, pick_em: 2, special: 3 }
  enum pick_type: { player: 0, card: 1 }

  accepts_nested_attributes_for :draft, allow_destroy: false

  def standings
    teams = []

    self.teams.each do |team|
      teams << team
    end

    teams.sort_by { |team| [-team.points, team.submitted_at] }
  end

  def any_unconfirmed_users?
    self.league_users.where(confirmed: false).count > 0
  end

  def user_confirmed? user
    LeagueUser.find_by(user_id: user, league_id: self).confirmed
  end

end
