Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'registrations'}
  resources :users, only: [:index]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#main'

  resources :tournaments, except: [:new, :edit] do
    resources :teams, only: [:index, :create]
    resources :rounds, only: [:index, :create, :show]
  end

  resources :rounds, only: [:update, :destroy] do
    resources :teams, only: [:index, :create]
    resources :matches, only: [:index]
  end

  resources :teams, only: [:show, :update, :destroy]
end
