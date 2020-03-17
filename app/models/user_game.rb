class UserGame < ApplicationRecord
    belongs_to :user
    belongs_to :game
    has_many :user_cards
    has_many :cards, through: :user_cards
    has_one :game_move
end
