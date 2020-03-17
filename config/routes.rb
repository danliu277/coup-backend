Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'rooms/', to: 'rooms#index'
  get 'rooms/:id', to: 'rooms#show'
  post 'rooms/', to: 'rooms#create'
  post 'rooms/:id', to: 'rooms#join'

  get 'users/', to: 'users#index'
  post 'users/', to: 'users#create'

  # To check users in game
  get 'user_games/room/:id', to: 'user_games#get_room_users'
  get 'user_games/game/:id', to: 'user_games#get_user_game'

  get 'games/:id', to: 'games#get_game'
  patch 'games/:id', to: 'games#start_game'

  post 'game_moves/:id', to: 'game_moves#execute_move'

  mount ActionCable.server => '/cable'
end
