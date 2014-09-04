Rails.application.routes.draw do
  resources :projects

  get '/logout' => 'main#logout', as: 'logout'
  root to: 'main#index'
end
