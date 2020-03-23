class GameSerializer < ActiveModel::Serializer
  attributes :id, :room_id, :user_game_id, :winner_id
  has_many :game_cards

  def game_cards
    self.object.game_cards.filter{|card| !card.deck}.map do |card|
      new_card = {}
      new_card[:id] = card.id
      new_card[:deck] = card.deck
      new_card[:game_id] = card.game_id
      new_card[:card_id] = card.card_id
      new_card[:name] = card.card.name
      new_card
    end
  end
end