class Game < ApplicationRecord
    belongs_to :room
    has_many :user_games
end
