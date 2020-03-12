class User < ApplicationRecord
    has_one :user_game
    has_one :room
    has_one :game, through: :user_game
end
