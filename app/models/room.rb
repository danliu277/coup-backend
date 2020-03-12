class Room < ApplicationRecord
    has_many :users
    belongs_to :user
    has_many :user_games

    has_secure_password
end
