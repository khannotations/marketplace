Rails.application.routes.draw do
  # Test routes
  mount JasmineRails::Engine => "/spec" if defined?(JasmineRails)

  # JSON routes

  # Users
  scope '/api' do
    get '/current_user' => 'users#current'
    resources :users, only: [:show, :update]
    put '/star/:project_id' => 'users#star'
    # Projects
    get '/projects/unapproved' => 'projects#unapproved'
    resources :projects, only: [:show, :create, :update, :destroy] do
      put '/approve' => 'projects#approve'
      put '/renew' => 'projects#renew'
      post '/contact' => 'projects#contact'
    end
    resources :skills, only: [:index, :create, :update, :destroy]

    get '/search/projects' => 'projects#search'
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
  get '/admin(/:page)' => 'main#index'
  get '/about' => 'main#index'

  # Template routes
  get '/templates/*path' => 'main#templates'

  root to: 'main#index'
end
