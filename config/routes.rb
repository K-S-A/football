Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations',
                                    omniauth_callbacks: 'callbacks' }

  root 'application#main'

  resources :users, only: [:index, :show]

  resources :tournaments, except: [:new, :edit], id: /\d+/ do
    resources :teams, only: [:create] do
      post 'generate', on: :collection
    end

    resources :rounds, only: [:index, :create, :show]
    resources :users, only: [:index]
    resources :assessments, only: [:create]

    get '/teams', to: 'tournaments#index_teams', on: :member
    post 'join', on: :member
    delete '/teams', to: 'tournaments#destroy_teams', on: :member
    delete '/users/:user_id', to: 'tournaments#remove_user', on: :member
  end

  resources :rounds, only: [:update, :destroy] do
    resources :matches, only: [:index, :create, :update] do
      post 'generate', on: :collection
    end

    get '/teams', to: 'rounds#index_teams', on: :member
    delete '/teams/:id', to: 'rounds#remove_team'
  end

  resources :teams, only: [:show, :update, :destroy] do
    delete '/users/:user_id', to: 'teams#remove_user', on: :member
  end

  resources :matches, only: [:destroy]
end
