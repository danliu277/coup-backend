class UserGamesController < ApplicationController
    def get_user_games
        user_games = Room.find(params[:id]).user_games
        render json: user_games
    end
end
