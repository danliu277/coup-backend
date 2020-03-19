class Game < ApplicationRecord
    belongs_to :room
    has_many :user_games
    has_many :game_cards
    has_many :cards, through: :game_cards
    has_one :game_move

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
        self.user_game_id = self.user_games.first.id
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
        # Use find to get updated data
        remaining_cards = Game.find(self.id).game_cards.filter{|card| card.deck}
    end

    def next_turn
        user_games = self.user_games.filter{|user_game| user_game.user_cards.length != 0}
        if(user_games.length > 1)
            user_games = user_games.sort_by{|user_game| user_game.id}
            index = user_games.index{|user_game| user_game.id === self.user_game_id}
            if index == user_games.length - 1
                self.user_game_id = user_games[0].id
            else
                self.user_game_id = user_games[index + 1].id
            end
        else
            self.winner_id = user_games[0].id
        end
    end
end
