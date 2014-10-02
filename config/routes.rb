Rails.application.routes.draw do
  resources :projects

  # Template routes
  get '/templates/*path' => 'main#templates'

  # JSON routes
  get '/current_user' => 'users#current'
  get '/logout' => 'main#logout', as: 'logout'
  root to: 'main#index'
end
