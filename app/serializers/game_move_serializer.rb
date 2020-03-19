class GameMoveSerializer < ActiveModel::Serializer
  attributes :id, :action, :target_id, :user_game_id, :game_id
end
