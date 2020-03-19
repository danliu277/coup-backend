class GameSerializer < ActiveModel::Serializer
  attributes :id, :room_id, :user_game_id, :winner_id
  has_many :game_cards
end
