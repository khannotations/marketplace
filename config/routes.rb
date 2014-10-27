Rails.application.routes.draw do
  # Test routes
  mount JasmineRails::Engine => "/spec" if defined?(JasmineRails)

  # JSON routes

  # Users
  scope '/api' do
    get '/current_user' => 'users#current'
    resources :users, only: [:show, :update]
    # post '/users/:user_id/skills/:skill_id' => 'skill_links#create'
    # delete '/users/:user_id/skills/:skill_id' => 'skill_links#destroy'

    # Projects and Openings
    resources :projects, only: [:show, :create, :update, :destroy] do
      resources :openings, only: [:create, :update, :destroy]
    end
    # post '/openings/:opening_id/skills/:skill_id' => 'skill_links#create'
    # delete '/openings/:opening_id/skills/:skill_id' => 'skill_links#destroy'

    resources :skills, only: [:index, :create, :update, :destroy]

    get '/search/openings' => 'openings#search'
    get '/search/users' => 'users#search'
  end

  # Authentication routes
  get '/logout' => 'main#logout', as: 'logout'
  get '/login' => 'main#login', as: 'login'
  get '/destroy_user' => 'main#destroy_user'
  
  # Whitelisted page routes
  get '/projects/:id' => 'main#index'
  get '/profile(/:id)' => 'main#index'
  get '/starred' => 'main#index'

  # Template routes
  get '/templates/*path' => 'main#templates'

  root to: 'main#index'
end
