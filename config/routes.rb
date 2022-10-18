Rails.application.routes.draw do
  get 'sessions/new'
  root 'timeline_pages#home'
  get '/signup', to: 'users#new'  
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  get '/twitter_test', to: 'twitter#test'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :lifelogs, only: %i[new create destroy update edit show]
  resources :relationships, only: %i[create destroy]
  resources :microposts, only: %i[new create edit update destroy show] do
    resources :verifications, only: %i[create destroy index]
    resources :comments, only: %i[create index destroy] do
      resources :likes, only: %i[create destroy index]
    end
    resources :likes, only: %i[create destroy index]
  end
end
