# Delete all entries
CompetitionPlayer.delete_all
Competition.delete_all
Draft.delete_all
Game.delete_all
Pick.delete_all
Player.delete_all
TournamentUser.delete_all
Tournament.delete_all
User.delete_all

# Create a game

game = Game.create(
  name: "Magic: the Gathering",
  category: "TCG"
)

# Create a competition

competition = Competition.create(
  game_id: game.id,
  name:
  "Pro Tour Aether Revolt",
  date: "2017-02-03 09:00:00",
  location: "Dublin, Ireland"
)

# Create a user and a tournament, add user to tournament

tournament_owner = user = User.create(
  name: "Admin McAdmin",
  email: "admin@admin.com",
  password: "password",
  password_confirmation: "password"
)

tournament = Tournament.create(
  user_id: tournament_owner.id,
  competition_id: competition.id
)

tournament.tournament_users.where(user_id: tournament_owner.id).first_or_create

# Create 7 more users and add them to the tournament

7.times do |i|
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name
  user = User.create(
    name: first_name + " " + last_name,
    email: Faker::Internet.unique.email(first_name + "." + last_name),
    password: Devise.friendly_token[0,20]
  )
  tournament.tournament_users.where(user_id: user.id).first_or_create
end

# Create all players in the PT Team Series

teams = []

almost_finnished = {
  name: "Almost Finnished",
  players: %w(
    Anssi\ Alkio
    Lauri\ Pispa
    Tuomas\ Tuominen
    Matti\ Kuisma
    Leo\ Lahonen
    Samuel\ Tharmaratnam
  )
}

teams << almost_finnished

basic = {
  name: "Basic",
  players: %w(
    Craig\ Chapman
    Sam-Luca\ Rolph
    Pip\ Griffiths
    Jaime\ Archdekan
    Mathew\ Stein
    Pete\ Ward
  )
}

teams << basic

cardhoarder = {
  name: "Cardhoarder",
  players: %w(
    Noah\ Walker
    Jacob\ Baugh
    Andrew\ Tenjum
    Robert\ Graves
    Zachary\ Kiihne
    Joe\ Lossett
  )
}

teams << cardhoarder

channelfireball_fire = {
  name: "ChannelFireball Fire",
  players: %w(
    Patrick\ Cox
    Matthew\ Nass
    Martin\ Jůza
    Josh\ Utter-Leyton
    Corey\ Burkhart
    Paul\ Cheon
  )
}

teams << channelfireball_fire

channelfireball_ice = {
  name: "ChannelFireball Ice",
  players: %w(
    Paulo\ Vitor\ Damo\ da\ Rosa
    Mike\ Sigrist
    Joel\ Larsson
    Ben\ Stark
    Ondřej\ Stráský
    Eric\ Froehlich
  )
}

teams << channelfireball_ice

conflagreece = {
  name: "Conflagreece",
  players: %w(
    Panagiotis\ Papadopoulos
    Bill\ Chronopoulos
    Dimitris\ Triantafillou
    Petros\ Tziotis
    Makis\ Matsoukas
    Nikolaos\ Kaponis
  )
}

teams << conflagreece

d3_go = {
  name: "D3 Go!",
  players: %w(
    Ben\ Rubin
    Tom\ Martell
    Matthew\ Costa
    Jelger\ Wiegersma
    Shahar\ Shenhar
    Brock\ Parker
  )
}

teams << d3_go

dave_and_adams = {
  name: "Dave & Adam's",
  players: %w(
    Alex\ Bianchi
    Andrew\ Skorik
    Nick\ D'Ambrose
    Joey\ Manner
    Jacky\ Wang
    Alex\ Bastecki
  )
}

teams << dave_and_adams

dex_army = {
   name: "Dex Army",
   players: %w(
     Willy\ Edel
     Márcio\ Carvalho
     Carlos\ Romão
     Thiago\ Saporito
     Luis\ Salvatto
     Antonio\ Del\ Moral\ León
   )
}

teams << dex_army

dexthird = {
  name: "Dexthird",
  players: %w(
    Felipe\ Valdivia
    Patrick\ Fernandes
    Cristian\ Cespedes
    Jose Luis\ Echeverria
    João Lucas\ Caparroz
    Lucas Esper\ Berthoud
  )
}

teams << dexthird

eureka = {
  name: "Eureka",
  players: %w(
    Immanuel\ Gerschenson
    Valentin\ Mackl
    Patrick\ Dickmann
    Steve\ Hatto
    Aleksa\ Telarov
    Marc\ Tobiasch
  )
}

teams << eureka

face_to_face_games = {
  name: "Face To Face Games",
  players: %w(
    Alexander\ Hayne
    Samuel\ Pardee
    Steve\ Rubin
    Jacob\ Wilson
    Ivan\ Floch
    Oliver\ Tiu
  )
}

teams << face_to_face_games

fire_squad = {
  name: "Fire Squad",
  players: %w(
    Thien\ Nguyen
    Nathaniel\ Smith
    David\ Shiels
    Ben\ Hull
    Brandon\ Ayers
    Jonathan\ Morawski
  )
}

teams << fire_squad

genesis = {
  name: "Genesis",
  players: %w(
    Brad\ Nelson
    Lukas\ Blohon
    Seth\ Manfield
    Michael\ Majors
    Martin\ Dang
    Martin\ Müller
  )
}

teams << genesis

hareruya = {
  name: "Hareruya",
  players: %w(
    Tomoharu\ Saito
    Shuhei\ Nakamura
    Yuta\ Takahashi
    Jérémy\ Dezani
    Oliver\ Polak-Rottmann
    Petr\ Sochůrek
  )
}

teams << hareruya

hotsauce_games = {
  name: "Hotsauce Games",
  players: %w(
    Raymond\ Perez,\ Jr.
    Gregory\ Orange
    Tyler\ Hill
    Cody\ Lingelbach
    Gabe\ Carleton-Barnes
    Stephen\ Neal
  )
}

teams << hotsauce_games

last_samurai = {
  name: "Last Samurai",
  players: %w(
    Kenji\ Tsumura
    Tsuyoshi\ Fujita
    Masashi\ Oiso
    Makihito\ Mihara
    Kazuyuki\ Takimura
    Ryoichi\ Tamada
  )
}

teams << last_samurai

ligamagic = {
  name: "Ligamagic",
  players: %w(
    Pedro\ Carvalho
    Eduardo\ dos\ Santos\ Vieira
    Sebastian\ Pozzo
    Guilherme\ Merjam
    Marcelino\ Freeman
    Marcos\ Paulo\ de\ Jesus\ Freitas
  )
}

teams << ligamagic

lingering_souls = {
  name: "Lingering Souls",
  players: %w(
    Shaheen\ Soorani
    Chris\ Fennell
    Travis\ Woo
    Andreas\ Ganz
    Ashraf\ Abou Omar
    Donald\ Smith
  )
}

teams << lingering_souls

magic_corsairs_crew = {
  name: "Magic Corsairs Crew",
  players: %w(
    Eliott\ Boussaud
    Maxime\ Martin
    Julien\ Stihle
    Samuel\ Vuillot
    Pierre\ Sommen
    Martin\ Hrycej
  )
}

teams << magic_corsairs_crew

massdrop_east = {
  name: "Massdrop East",
  players: %w(
    Pascal\ Maynard
    Jarvis\ Yu
    Ricky\ Chin
    Timothy\ Wu
    Eric\ Severson
    Jon\ Stern
  )
}

teams << massdrop_east

massdrop_west = {
  name: "Massdrop West",
  players: %w(
    Mark\ Jacobson
    Paul\ Dean
    Jiachen\ Tao
    Ari\ Lax
    Scott\ Lipp
    Ben\ Weitz
  )
}

teams << massdrop_west

mox_box_bowl = {
  name: "Mox Box Bowl",
  players: %w(
    Ben\ Friedman
    Alex\ Majlaton
    Eugene\ Hwang
    Rob\ Pisano
    Brandon\ Fischer
    Paul\ Yeem
  )
}

teams << mox_box_bowl

mtg_bent_card = {
  name: "MTG Bent Card",
  players: %w(
    Andrea\ Mengucci
    Anthony\ Lee
    Javier\ Dominguez
    Christian\ Calcano
    Michael\ Bonde
    Corey\ Baumeister
  )
}

teams << mtg_bent_card

mtg_mint_card = {
  name: "MTG Mint Card",
  players: %w(
    Lee\ Shi\ Tian
    Jason\ Chung
    Huang\ Hao-Shan
    Kelvin\ Chew
    Eduardo\ Sajgalik
    Nam\ Sung\ Wook
  )
}

teams << mtg_mint_card

mushashi = {
  name: "Mushashi",
  players: %w(
    Kentaro\ Yamamoto
    Yuuya\ Watanabe
    Ken\ Yukuhiro
    Yuuki\ Ichikawa
    Teruya\ Kakumae
    Shota\ Yasooka
  )
}

teams << mushashi

mutiny = {
  name: "Mutiny",
  players: %w(
    David\ Ochoa
    Joshua\ Cho
    Gerry\ Thompson
    Justin\ Cohen
    Matthew\ Severa
    Samuel\ Black
  )
}

teams << mutiny

norcal = {
  name: "Norcal",
  players: %w(
    Jason\ Smyth
    Mike\ Mei
    Huaxing\ Bai
    Harold\ Chow
    Caleb\ Van\ Patten
    Dan\ Besterman
  )
}

teams << norcal

opportunity = {
  name: "Opportunity",
  players: %w(
    Pierre\ Dagen
    Magnus\ Lantto
    Gabriel\ Nassif
    Grzegorz\ Kowalski
    Matteo\ Moure
    Marco\ Cammilluzzi
  )
}

teams << opportunity

puzzle_quest = {
  name: "Puzzle Quest",
  players: %w(
    Reid\ Duke
    Owen\ Turtenwald
    William\ Jensen
    Jon\ Finkel
    Andrew\ Cuneo
    Paul\ Rietzl
  )
}

teams << puzzle_quest

tapas = {
  name: "Tapas",
  players: %w(
    Ryan\ Cubit
    David\ Mines
    James\ Wilks
    Garry\ Lau
    Riccardo\ Bragato
    Matthew\ Anderson
  )
}

teams << tapas

top_level = {
  name: "Top Level",
  players: %w(
    Craig\ Wescoe
    Raphaël\ Lévy
    Patrick\ Chapin
    Brian\ Braun-Duin
    Mike\ Hron
    Dan\ Lanthier
  )
}

teams << top_level

teams.each do |team|
  puts "Creating #{team[:name]}"
  team[:players].each do |name|
    puts "***** Creating #{name}"
    player = Player.where(name: name, team: team[:name]).first_or_create
    player.competition_players.where(competition_id: competition.id).first_or_create
  end
end
