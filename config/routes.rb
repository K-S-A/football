Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'registrations'}
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'application#main'

  resources :users, only: [:index]

  resources :tournaments, except: [:new, :edit], id: /\d+/ do
    resources :teams, only: [:index, :create]
    resources :rounds, only: [:index, :create, :show]
    resources :users, only: [:index]
    resources :assessments, only: [:create]
  end

  resources :rounds, only: [:update, :destroy] do
    # resources :teams, only: [:index, :create]
    resources :matches, only: [:index, :create, :update]
  end

  resources :teams, only: [:show, :update, :destroy]
  resources :matches, only: [:destroy]
end
