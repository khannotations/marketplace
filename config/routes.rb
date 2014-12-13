Rails.application.routes.draw do
  # Test routes
  mount JasmineRails::Engine => "/spec" if defined?(JasmineRails)

  # JSON routes

  # Users
  scope '/api' do
    get '/current_user' => 'users#current'
    resources :users, only: [:show, :update]
    put '/star/:opening_id' => 'users#star'

    # Projects and Openings
    get '/projects/unapproved' => 'projects#unapproved'
    put '/projects/:id/approve' => 'projects#approve'
    resources :projects, only: [:show, :create, :update, :destroy]
    put '/openings/:id/renew' => 'openings#renew'
    post '/openings/:id/contact' => 'openings#contact'
    resources :openings, only: [:show, :create, :update, :destroy]
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
  get '/admin(/:page)' => 'main#index'
  get '/about' => 'main#index'

  # Template routes
  get '/templates/*path' => 'main#templates'

  root to: 'main#index'
end
