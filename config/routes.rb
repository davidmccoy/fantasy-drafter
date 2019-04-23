require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'
  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  root 'home#index'

  devise_for :users, :controllers => { :registrations => "users/registrations" }

  resources :users

  devise_scope :user do
    match '/user/leagues', to: 'users#leagues', via: [:get]
    match '/user/invites', to: 'users#invites', via: [:get]
  end

  resources :invites
  resources :players, only: [:new, :import]
  post 'players/import', to: 'players#import'
  resource :faq
  resource :contact_us, controller: 'contact_us'

  resources :games, param: :slug, only: [:index, :new] do
    resources :seasons, param: :slug do
      resources :leagues, controller: 'seasons/leagues' do
        match 'join', to: 'seasons/leagues#join', via: [:get]
        post 'group_invite', to: 'leagues/group_invite'
        resources :league_users, controller: 'seasons/league_users' do
          match 'confirm', to: 'seasons/league_users#confirm', via: [:get]
          match 'resend_invite', to: 'seasons/league_users#resend_invite', via: [:get]
        end
        resources :teams, controller: 'seasons/teams'
        resources :drafts, controller: 'seasons/drafts' do
          post 'start', to: 'seasons/drafts#start'
          post 'submit', to: 'seasons/drafts#submit'
          put 'picks/pick_x', to: 'seasons/picks#pick_x'
          put 'picks/remove_player', to: 'seasons/picks#remove_player'
          resources :picks, controller: 'seasons/picks'
          resources :stars, controller: 'seasons/stars'
        end
      end
    end
    resources :competitions, param: :slug, only: [:index, :show] do
      match 'results/import', to: 'results#import', via: [:post]
      match 'results/team_import', to: 'results#team_import', via: [:post]
      resources :results do
      end
      resources :competition_players, path: 'players', only: [:index, :show]
      resources :leagues do
        match 'join', to: 'leagues#join', via: [:get]
        post 'group_invite', to: 'leagues/group_invite'
        resources :league_users do
          match 'confirm', to: 'league_users#confirm', via: [:get]
          match 'resend_invite', to: 'league_users#resend_invite', via: [:get]
        end
        resources :teams
        resources :drafts do
          post 'start', to: 'drafts#start'
          post 'submit', to: 'drafts#submit'
          put 'picks/pick_x', to: 'picks#pick_x'
          put 'picks/special', to: 'picks#special'
          put 'picks/remove_player', to: 'picks#remove_player'
          resources :picks
          resources :stars
        end
      end
    end
  end

  namespace :api, defaults: { format: :json } do
    authenticated :user do
      resources :drafts do
        get 'available_players', to: 'drafts#available_players'
        get 'all_teams', to: 'drafts#all_teams'
        resources :stars, only: [:index]
      end
      resources :players, only: [:show]
      resources :cards, only: [:show]
    end
    resource :subscriber, only: [:create]

  end

  # Admin #
  #########
  namespace :admin do
    root to: 'dashboard#dashboard'
    resources :leagues
    resources :competitions, param: :slug do
      match 'players/import', to: 'competition_players#import', via: [:post]
      resources :competition_players, path: 'players'
      match 'card_competitions/import', to: 'card_competitions#import', via: [:post]
      resources :card_competitions, path: 'cards'
    end
    get 'players/stats', to: 'players#stats'
    post 'players/add_stats', to: 'players#add_stats'
    resources :players
    resources :cards
    post 'cards/import', to: 'cards#import'
    resources :seasons do
      resources :leagues
    end
  end

  # Redirects #
  #############

  get '/sparkmadness', to: 'redirects#sparkmadness'
  get '/mythic-invitational', to: 'redirects#mythic_invitational'
  get '/mythic-championship', to: 'redirects#mythic_championship'
end
