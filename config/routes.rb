Rails.application.routes.draw do
  root 'timeline_pages#home'
  get '/signup', to: 'users#new'
  resources :users
end
