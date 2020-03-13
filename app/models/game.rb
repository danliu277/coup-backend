class Game < ApplicationRecord
    belongs_to :room
    has_many :user_games

    def start_game
        self.started = true
    end
end
