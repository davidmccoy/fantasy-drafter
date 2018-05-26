class League < ApplicationRecord

  belongs_to :leagueable, polymorphic: true
  has_many :league_users, dependent: :destroy
  has_many :users, through: :league_users
  belongs_to :admin, class_name: "User", foreign_key: "user_id"
  has_one :draft, dependent: :destroy
  has_many :teams, through: :league_users

  accepts_nested_attributes_for :draft

  def standings
    teams = []

    self.teams.each do |team|
      teams << team
    end

    teams.sort_by { |team| team.points }.reverse
  end

  def any_unconfirmed_users?
    self.league_users.where(confirmed: false).count > 0
  end

end
