Rails.application.routes.draw do
  root :to => 'sources#index'
  get '/cloud' => 'sources#cloud'
  get '/cloud_data/:id' => 'sources#cloud_data'
  resources :sources 

end
