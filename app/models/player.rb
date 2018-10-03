class Player < ApplicationRecord

  has_many :picks
  has_many :competition_players
  has_many :competitions, through: :competition_players
  has_many :results

  def result competition
    self.results.find_by(competition_id: competition.id)
  end

  def season_results season
    competitions = Competition.where(season_id: season).pluck(:id)
    self.results.find_by(competition_id: competitions)
  end

  def points_per_result
    points = 0
    num_results = self.results.count

    return 0 if num_results == 0

    self.results.each do |result|
      points = points + result.points
    end

    return points / num_results
  end

  def self.unaccent(name)
      player = self.where(
        "translate(
          LOWER(name),
          'âãäåāăąÁÂÃÄÅĀĂĄèééêëēĕėęěĒĔĖĘĚìíîïìĩīĭÌÍÎÏÌĨĪĬóôõöōŏőÒÓÔÕÖŌŎŐùúûüũūŭůÙÚÛÜŨŪŬŮ',
          'aaaaaaaaaaaaaaaeeeeeeeeeeeeeeeiiiiiiiiiiiiiiiiooooooooooooooouuuuuuuuuuuuuuuu'
        )
        ILIKE ?", "#{ActiveSupport::Inflector.transliterate("#{name}").downcase}"
      )
      player.first
  end

end
