class Admin::CardsController < ApplicationController
  before_action :authenticate_admin

  def new
  end

  def import
    file = CSV.read(params[:file].path)

    errors = []
    file.each do |row|
      card_name = row[0]
      card = Card.find_by_name(card_name)
      if card
        p 'found card'
        card
      else
        p "finding #{card_name}"
        if card_name.include? ','
          url_safe_card_name = card_name.gsub!(/\,/,"").downcase.split(' ').join('+')
        else
          url_safe_card_name = card_name.downcase.split(' ').join('+')
        end
        url = "https://api.scryfall.com/cards/named?exact=#{url_safe_card_name}"
        p url
        response = HTTParty.get(url)
        if response.code == 200
          if response['card_faces']
            image = response['card_faces'].first['image_uris']['normal']
          else 
            image = response['image_uris']['normal']
          end 
          Card.create(
            scryfall_id: response['id'],
            oracle_id: response['oracle_id'],
            name: card_name,
            image_uri: image,
            mana_cost: response['mana_cost'],
            cmc: response['cmc'],
            type_line: response['type_line'],
            oracle_text: response['oracle_text'],
            power: response['power'],
            toughness: response['toughness'],
            loyalty: response['loyalty'],
            colors: response['colors'],
            legalities: response['legalities'],
            rarity: response['rarity'],
            flavor_text: response['flavor_text'],
            artist: response['artist'],
            frame: response['frame']
          )
        else 
          p response.code
          errors << card_name
        end 
      end
    end
    puts errors
    redirect_to admin_root_path
  end
end
