class Game < ApplicationRecord
    belongs_to :room
    has_many :user_games

    def start_game
        self.started = true
        self.deck = []
        self.user_games.each do |user_game|
            debugger
        end
    end
end