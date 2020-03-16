class Game < ApplicationRecord
    belongs_to :room
    has_many :user_games
    has_many :game_cards
    has_many :cards, through: :game_cards
    has_many :user_cards, through: :user_games, source: 

    def start_game
        self.started = true
        Card.all.each{|card| GameCard.create(deck: true, card: card, game: self)}
        self.user_games.each do |user_game|
            2.times {
                game_card = self.remaining_cards.sample
                UserCard.create(user_game: user_game, card: game_card.card)
                game_card.destroy
            }
        end
        return nil
    end

    def user_cards
        cards = []
        self.user_games.each do |user_game|
            cards.push(user_game.cards)
        end
        return cards.flatten
    end

    def remaining_cards
        remaining_cards = self.game_cards.filter{|card| card.deck}
    end
end
