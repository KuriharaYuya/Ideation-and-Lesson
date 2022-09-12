Rails.application.routes.draw do
  root 'timeline_pages#home'
  get '/signup', to: 'users#new'
  get '/profile', to: 'users#profile'
end
