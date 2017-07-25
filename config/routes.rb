Rails.application.routes.draw do

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

  resources :games, only: [:index] do
    resources :competitions, only: [:index] do
      match 'results/import', to: 'results#import', via: [:post]
      resources :results do
      end
      match 'players/import', to: 'competition_players#import', via: [:post]
      resources :competition_players, path: 'players'
      resources :leagues do
        resources :league_users do
          match 'confirm', to: 'league_users#confirm', via: [:get]
          match 'resend_invite', to: 'league_users#resend_invite', via: [:get]
        end
        resources :teams
        resources :drafts do
          resources :picks
        end
      end
    end
  end


end
