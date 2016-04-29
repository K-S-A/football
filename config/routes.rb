Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'registrations'}

  root 'application#main'

  resources :users, only: [:index, :show]

  resources :tournaments, except: [:new, :edit], id: /\d+/ do
    resources :teams, only: [:index, :create]
    resources :rounds, only: [:index, :create, :show]
    resources :users, only: [:index]
    resources :assessments, only: [:create]
  end

  resources :rounds, only: [:update, :destroy] do
    resources :teams, only: [:index]
    resources :matches, only: [:index, :create, :update]
  end

  resources :teams, only: [:show, :update, :destroy]
  resources :matches, only: [:destroy]
end
