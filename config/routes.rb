Rails.application.routes.draw do
  root :to => 'sources#index'

  resources :sources 

  get '/searcher' => 'sources#index'
  post '/searcher' => 'sources#index'
end
