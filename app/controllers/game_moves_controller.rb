class GameMovesController < ApplicationController
    def execute_move(game_move)
        # game = Game.find(params[:id])
        # user_game = UserGame.find(params[:user_game_id])
        # target_game = params[:target_id] ? UserGame.find(params[:target_id]) : nil
        # handle_move(params[:game_move][:action], game, user_game, target_game)
        # game = Game.find(params[:id])
        game = game_move.game
        target = game_move.target_id ? UserGame.find(game_move.target_id) : nil
        handle_move(game_move.action, game, game_move.user_game, target)
        game.next_turn
        game.save
        GamesChannel.broadcast_to game, message: true
        # render json: user_game
    end 

    def broadcast_move
        game = Game.find(params[:id])
        game_move = GameMove.create(action: params[:game_move][:action], target_id: params[:target_id], game: game, user_game_id: params[:user_game_id])
        serialized_data = ActiveModelSerializers::Adapter::Json.new(
            GameMoveSerializer.new(game_move)
        ).serializable_hash
        GamesChannel.broadcast_to game, serialized_data
    end

    def reaction
        game = Game.find(params[:id])
        game_move = game.game_move
        case params[:reaction]
        when 0
            if !game_move.reactions.include?(params[:user_game_id])
                if game.user_games.length - 1 == game_move.reactions.length
                    execute_move(game_move)
                    game_move.destroy
                else
                    game_move.reactions.push(params[:user_game_id])
                    game_move.save
                end
            end
        when 1
        when 2
        end
    end

    def draw_two
        game = Game.find(params[:id])
        drawn_cards = game.remaining_cards.sample(2).map{|game_card| game_card.card}
        render json: drawn_cards
    end

    def swap_cards
        game = Game.find(params[:id])
        user_game = UserGame.find(params[:user_game_id])
        # Remove relation between user and card and create relation between card and deck
        # Put cards back in deck
        params[:selected_hand].each do |card_id|
            user_card = user_game.user_cards.find_by(card_id: card_id)
            user_card.destroy
            GameCard.create(deck: true, card_id: card_id, game: game)
        end
        # Remove relation between card and deck and create relation between user and card
        # Add cards to user
        params[:selected_draw].each do |card_id|
            game_card = game.game_cards.find_by(card_id: card_id)
            game_card.destroy
            UserCard.create(user_game: user_game, card_id: card_id)
        end
        game = Game.find(params[:id])
        game.next_turn
        game.save
        GamesChannel.broadcast_to game, message: true
        render json: UserGame.find(params[:user_game_id])
    end

    private def handle_move(action, game, user_game, target_game)
        case action
        # Income gain 1 coin
        when 0
            user_game.money += 1
            user_game.save
        # Foreign aid gain 2 coins
        when 1
            user_game.money += 2
            user_game.save
        # Coup lose 7 coins, target loses a card
        when 2
            if user_game.money >= 7
                user_game.money -= 7
                target_card = target_game.user_cards.sample
                GameCard.create(deck: false, card: target_card.card, game: game)
                target_card.destroy
                user_game.save
            end
        # Duke gain 3 coins
        when 3
            user_game.money += 3
            user_game.save
        # Assassin lose 3 coins, target lose card
        when 4
            if user_game.money >= 3
                user_game.money -=3
                target_card = target_game.user_cards.sample
                GameCard.create(deck: false, card: target_card.card, game: game)
                target_card.destroy
                user_game.save
            end
        # Captain steal 3 coins from target
        when 5
            if target_game.money >= 2
                user_game.money += 2
                target_game.money -= 2
            else
                user_game.money += target_game.money
                target_game.money = 0
            end
            user_game.save
            target_game.save
        # Ambassador can change 2 cards
        when 6
        end
    end
end
