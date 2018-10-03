class Team < ApplicationRecord

  belongs_to :league_user
  has_one :user, through: :league_user
  has_one :league, through: :league_user
  has_many :picks
  has_many :players, through: :picks

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


end
