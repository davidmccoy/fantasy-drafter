class Player < ApplicationRecord
  require 'open-uri'

  has_many :picks, as: :pickable
  has_many :competition_players
  has_many :competitions, through: :competition_players
  has_many :results, as: :resultable
  has_many :player_records
  has_many :matches

  enum player_type: { player: 0, card: 1, deck: 2 }

  def seed(competition)
    competition_players.find_by(competition_id: competition.id)&.seed
  end

  def matches
    Match.where("player_a_id = ? OR player_b_id = ?", id, id)
  end

  def group(competition)
    competition_players.find_by(competition_id: competition.id)&.group
  end

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

  def update_stats
    puts name
    url = get_stats_url
    doc = Nokogiri::HTML(open(url))
    player_name_div = doc.css('div.playerName')

    if !player_name_div.empty?
      # Team
      team = doc.css('.teamdropbtn').text == "" ? nil : doc.css('.teamdropbtn').text
      # ELO
      elo = doc.css('.headerRating').css('font').text.to_i

      # Player's GP and PT records
      player_records = doc.css('.record').text.gsub(doc.css('.record').css('.dropdown').text, '').gsub('Record: ', '')
      gp_record = nil
      pt_record = nil

      if player_records.include? " / "
        player_records.split(' / ').each do |record|
          if record.include? '(GP)'
            gp_record = record.split(' ')[0]
          elsif record.include? '(professional)'
            pt_record = record.split(' ')[0]
          else
            puts '*** record error ***'
          end
        end
      else
        gp_record = player_records
        pt_record = nil
      end

      self.update(team: team, elo: elo, gp_record: gp_record, pt_record: pt_record, stats_url: url, stats_updated_at: Time.now)

      gp_tables = doc.css('table.gpbox')
      gp_tables.each do |table|
        # GP name
        competition_name = table.css('td.gpname').css('a').first&.text&.gsub(/\([^()]*\)/,"")&.strip
        # GP format
        competition_format = table.css('td.gpname').css('span.format')&.text&.strip&.gsub('(', '')&.gsub(')', '')&.split(' ')&.map { |word| word.length == 3 ? word.upcase : word.capitalize }&.join(' ')
        # GP record --> "6-8"
        competition_record = table.css('.totalRecord')&.text&.split(' ')[1]

        PlayerRecord.where(player_id: self.id, competition_name: competition_name, competition_format: competition_format, competition_record: competition_record).first_or_create
      end
    else
      p "*** can't find player page for #{name} ***"
    end
  end

  def unaccented_name
    ActiveSupport::Inflector.transliterate(name).to_s
  end

  private

  def get_stats_url
    if stats_url.nil?
      first_name = unaccented_name.split(' ')[0].downcase
      last_name = unaccented_name.split(' ')[1].downcase
      "http://www.mtgeloproject.net/index.php?lastname=#{last_name}&firstname=#{first_name}&search=Search"
    else
      stats_url
    end
  end
end
