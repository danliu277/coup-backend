class UserGamesController < ApplicationController
    def get_room_users
        user_games = Room.find(params[:id]).user_games
        render json: user_games
    end

    def get_user_game
        user_game = UserGame.find_by(user_id: params[:id])
        render json: user_game
    end
end
