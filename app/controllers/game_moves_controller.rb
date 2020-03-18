class GameMovesController < ApplicationController
    def execute_move
        game = Game.find(params[:id])
        user_game = UserGame.find(params[:user_game_id])
        target_game = params[:target_id] ? UserGame.find(params[:target_id]) : nil
        handle_move(params[:game_move][:action], game, user_game, target_game)
        render json: user_game
    end 

    def draw_two
        game = Game.find(params[:id])
        drawn_cards = game.remaining_cards.sample(2).map{|game_card| game_card.card}
        render json: drawn_cards
    end

    def swap_cards
        game = Game.find(params[:id])
        user_game = UserGame.find(params[:user_game_id])
        params[:selected_hand].each do |card_id|
            user_card = user_game.user_cards.find_by(card_id: card_id)
            user_card.destroy
            GameCard.create(deck: true, card_id: card_id, game: game)
        end
        params[:selected_draw].each do |card_id|
            game_card = game.game_cards.find_by(card_id: card_id)
            game_card.destroy
            UserCard.create(user_game: user_game, card_id: card_id)
        end
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
            user_game.money -= 7
            target_card = target_game.user_cards.sample
            GameCard.create(deck: false, card: target_card.card, game: game)
            target_card.destroy
            user_game.save
        # Duke gain 3 coins
        when 3
            user_game.money += 3
            user_game.save
        # Assassin lose 3 coins, target lose card
        when 4
            user_game.money -=3
            target_card = target_game.user_cards.sample
            GameCard.create(deck: false, card: target_card.card, game: game)
            target_card.destroy
            user_game.save
        # Captain steal 3 coins from target
        when 5
            user_game.money += 2
            target_game.money -= 2
            user_game.save
            target_game.save
        # Ambassador can change 2 cards
        when 6
        end
    end
end
