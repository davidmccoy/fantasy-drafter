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
      resources :leagues do
        resources :league_users do
          match 'confirm', to: 'league_users#confirm', via: [:get]
        end
        resources :teams
        resources :drafts do
          resources :picks
        end
      end
    end
  end


end
