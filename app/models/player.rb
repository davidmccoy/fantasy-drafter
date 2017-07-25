class Player < ApplicationRecord

  has_many :picks
  has_many :competition_players
  has_many :competitions, through: :competition_players
  has_many :results

  def result competition
    self.results.find_by(competition_id: competition.id)
  end

  def points_per_result
    points = 0
    num_results = self.results.count

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
