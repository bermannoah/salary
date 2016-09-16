Rails.application.routes.draw do

  root to: 'users#new'

  scope module: 'user' do
    resources :jobs
  end

  resources :users,  only: [:index, :new, :show, :create]

  namespace :admin do
    resources :stats, :users, :jobs
  end
  # resources :jobs

  get '/admin', to: 'admin#show'
  get '/admin/login', to: "sessions#new"
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  get '/slack', to: 'slack#handle'
  post '/slack', to: 'slack#index'
end
  