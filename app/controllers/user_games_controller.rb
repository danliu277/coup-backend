class UserGamesController < ApplicationController
    def get_user_games
        user_games = UserGame.where('room_id = ?', params[:id])
        render json: user_games
    end
end
