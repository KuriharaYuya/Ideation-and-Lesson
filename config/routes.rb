Rails.application.routes.draw do
  get 'sessions/new'
  get 'session/new'
  root 'timeline_pages#home'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :relationships, only: %i[create destroy]
end
