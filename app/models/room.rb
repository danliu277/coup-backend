class Room < ApplicationRecord
    has_many :users
    belongs_to :user
    has_one :game
    has_many :user_games, through: :game

    has_secure_password
end
