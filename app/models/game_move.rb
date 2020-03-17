class GameMove < ApplicationRecord
    belongs_to :user_game
    belongs_to :game
end
