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

  get 'game_moves/:id/draw_two', to: 'game_moves#draw_two'
  post 'game_moves/:id/reaction', to: 'game_moves#reaction'
  post 'game_moves/:id/call_bluff', to: 'game_moves#call_bluff'
  post 'game_moves/:id/block', to: 'game_moves#block'
  post 'game_moves/:id', to: 'game_moves#broadcast_move'

  mount ActionCable.server => '/cable'
end
