class Card < ApplicationRecord
    has_many :user_cards
    has_many :game_cards
end
