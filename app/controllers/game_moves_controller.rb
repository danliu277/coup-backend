class GameMovesController < ApplicationController
    def execute_move
        game = Game.find(params[:id])
        user_game = UserGame.find(params[:user_game_id])
        target_game = params[:target_id] ? UserGame.find(params[:target_id]) : nil
        handle_move(params[:game_move][:action], game, user_game, target_game)
        render json: user_game
    end 

    private def handle_move(action, game, user_game, target_game)
        case action
        when 0
            user_game.money += 1
            user_game.save
        when 1
            user_game.money += 2
            user_game.save
        when 2
            user_game.money -= 7
            user_game.save
        when 3
            user_game.money += 3
            user_game.save
        when 4
            user_game.money -=3
            user_game.save
        when 5
            user_game.money += 2
            target_game.money -= 2
            user_game.save
            target_game.save
        when 6
        end
    end
end
