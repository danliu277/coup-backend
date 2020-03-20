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
        if(game_move.action < 6)
            game.next_turn
            game.save
        end
        game_move.destroy
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
        # Pass
        when 0
            if !game_move.reactions.include?(params[:user_game_id])
                if game.user_games.length - 2 == game_move.reactions.length
                    execute_move(game_move)
                    game_move.destroy
                else
                    game_move.reactions.push(params[:user_game_id])
                    game_move.save
                end
            end
        # Block
        when 1

            game_move.destroy
        # Call bluff
        when 2
            game_move.target_id = 1
            serialized_data = ActiveModelSerializers::Adapter::Json.new(
                GameMoveSerializer.new(game_move)
            ).serializable_hash
            GamesChannel.broadcast_to game, game_move
            game_move.destroy
        end
    end

    def draw_two(game, user_game_id)
        # game = Game.find(params[:id])
        drawn_cards = game.remaining_cards.sample(2).map{|game_card| game_card.card}
        # render json: drawn_cards
        GamesChannel.broadcast_to game, message: {user_game_id: user_game_id, drawn_cards: drawn_cards}
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

    def call_bluff
        game = Game.find(params[:id])
        game_move = game.game_move
        if(check_card(game_move))
            target_game = UserGame.find(params[:user_game_id])
            target_card = target_game.user_cards.sample
            target_card.destroy
            execute_move(game_move)
        else
            user_game = UserGame.find(params[:user_game_id])
            target_card = user_game.user_cards.sample
            target_card.destroy
            game.next_turn
            game.save
        end
        game_move.destroy
        GamesChannel.broadcast_to game, message: true
    end

    def block
        game = Game.find(params[:id])
        game_move = game.game_move
        # game_move.destroy
        # game.next_turn
        # game.save
        # game_move.destroy
        block_move = nil
        case game_move.action
        # block foreign aid
        when 1
            block_move = GameMove.create(action: 7, game: game, user_game_id: params[:user_game_id], target_id: game.game_move.user_game_id)
        # block assassin
        when 4
            block_move = GameMove.create(action: 8, game: game, user_game_id: params[:user_game_id], target_id: game.game_move.user_game_id)
        # block steal
        when 5
            block_move = GameMove.create(action: 9, game: game, user_game_id: params[:user_game_id], target_id: game.game_move.user_game_id)
        # block ambassador
        when 5
            block_move = GameMove.create(action: 10, game: game, user_game_id: params[:user_game_id], target_id: game.game_move.user_game_id)
        end
        serialized_data = ActiveModelSerializers::Adapter::Json.new(
            GameMoveSerializer.new(block_move)
        ).serializable_hash
        GamesChannel.broadcast_to game, serialized_data
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
            draw_two(game, user_game.id)
        end
    end

    private def check_card(game_move)
        user_game = UserGame.find(game_move.target_id)
        case game_move.action
        # Duke
        when 3
            return user_game.cards.any?{|card| card.value == 4}
        # Assasissin
        when 4
            return user_game.cards.any?{|card| card.value == 3}
        # Captain
        when 5
            return user_game.cards.any?{|card| card.value == 5}
        # Ambassador
        when 6
            return user_game.cards.any?{|card| card.value == 1}
        end
    end
end
