Rails.application.routes.draw do
  resources :projects

  # JSON routes
  get '/current_user' => 'users#current'
  resources :users, only: [:show, :update]
  post '/users/:user_id/skills/:skill_id' => 'skill_links#create'
  delete '/users/:user_id/skills/:skill_id' => 'skill_links#destroy'

  # Search
  get '/search' => 'main#search'
  # Projects
  resources :projects, only: [:show, :create, :update, :destroy] do
    resources :openings, only: [:create, :update, :destroy]
  end

  post '/openings/:opening_id/skills/:skill_id' => 'skill_links#create'
  delete '/openings/:opening_id/skills/:skill_id' => 'skill_links#destroy'

  # Authentication routes
  get '/logout' => 'main#logout', as: 'logout'
  get '/login' => 'main#login', as: 'login'
  get '/destroy_user' => 'main#destroy'
  # Whitelisted page routes

  # Template routes
  get '/templates/*path' => 'main#templates'

  root to: 'main#index'
end
