Rails.application.routes.draw do

  root 'home#index'

  devise_for :users

  devise_scope :user do
    match '/users/tournaments', to: 'users#tournaments', via: [:get]
  end

  resources :games, only: [:index] do
    resources :competitions, only: [:index] do
      resources :tournaments do
        resources :tournament_users
        resources :drafts do
          resources :picks
        end
      end
    end
  end


end
