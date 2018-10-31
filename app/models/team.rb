class Team < ApplicationRecord

  belongs_to :league_user
  has_one :user, through: :league_user
  has_one :league, through: :league_user
  has_many :picks
  has_many :players, through: :picks, source: :pickable, source_type: 'Player'
  has_many :cards, through: :picks, source: :pickable, source_type: 'Card'

  validate :unique_team_names

  def points
    points = 0

    self.players.each do |player|
      result = player.result(self.league.leagueable)
      if result
        points = points + result.points
      end
    end

    points
  end

  def season_points
    points = 0

    self.players.each do |player|
      result = player.season_results(self.league.leagueable)
      if result
        points = points + result.points
      end
    end

    points
  end

  private

  def unique_team_names
    team_with_matching_name =
      league.teams.where(
        'lower(name) = ?',
        name.downcase
      )

    errors.add(
      :name,
      "A team with the name \"#{name}\" already exists."
    ) unless team_with_matching_name.empty? || team_with_matching_name.include?(self)
  end


end
