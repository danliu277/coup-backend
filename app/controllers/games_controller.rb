class GamesController < ApplicationController
    def get_game
        game = Game.find_by(room_id: params[:id])
        render json: game
    end

    def start_game
        game = Game.find_by(room_id: params[:id])
        game.start_game
        game = Game.find_by(room_id: params[:id])
        serialized_data = ActiveModelSerializers::Adapter::Json.new(
            GameSerializer.new(game)
        ).serializable_hash
        GamesChannel.broadcast_to game, serialized_data
        render json: game
    end
end
