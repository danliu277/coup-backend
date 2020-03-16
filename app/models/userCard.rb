class UserCard < ApplicationRecord
    belongs_to :user_game
    belongs_to :card
end
