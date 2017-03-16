Rails.application.routes.draw do

  root 'home#index'

  devise_for :users

  resources :games, only: [:index] do
    resources :competitions, only: [:index] do
      resources :tournaments
    end
  end


end
