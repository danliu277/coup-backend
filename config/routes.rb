Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'rooms/', to: 'rooms#index'
  get 'rooms/:id', to: 'rooms#show'
  post 'rooms/', to: 'rooms#create'
  post 'rooms/:id', to: 'rooms#join'

  get 'users/', to: 'users#index'
  post 'users/', to: 'users#create'

  mount ActionCable.server => '/cable'
end
