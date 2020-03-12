class Game < ApplicationRecord
    belongs_to :room
    has_many :user_games
    has_many :users, through: :user_games
end
