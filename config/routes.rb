Rails.application.routes.draw do
  resources :projects

  # Template routes
  get '/templates/*path' => 'templates#public'
  get '/logout' => 'main#logout', as: 'logout'
  root to: 'main#index'
end
