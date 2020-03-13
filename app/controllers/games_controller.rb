class GamesController < ApplicationController
    def get_game
        game = Game.find_by(room_id: params[:id])
        render json: game
    end

    def start_game
        game = Game.find_by(room_id: params[:id])
        render json: game
    end
end
