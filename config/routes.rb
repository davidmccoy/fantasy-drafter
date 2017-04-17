Rails.application.routes.draw do

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'

  root 'home#index'

  devise_for :users

  devise_scope :user do
    match '/users/leagues', to: 'users#leagues', via: [:get]
  end

  resources :games, only: [:index] do
    resources :competitions, only: [:index] do
      resources :leagues do
        resources :league_users
        resources :drafts do
          resources :picks
        end
      end
    end
  end


end
