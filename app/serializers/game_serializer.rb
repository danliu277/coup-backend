class GameSerializer < ActiveModel::Serializer
  attributes :id, :room_id
  has_many :game_cards
end
