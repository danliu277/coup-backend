class RoomsController < ApplicationController
    def index
        rooms = Room.all
        render json: rooms
    end

    def show
        rooms = Room.find(params[:id])
        render json: room
    end

    def create
        room = Room.new(room_params)
        # if(!room.password)
        #     room.password = room.password_confirmation = ""
        #     room.password_digest = "authorized account"
        # end
        if room.save
            game = Game.create(room: room)
            usergame = UserGame.create(game: game, user_id: room_params[:user_id])
            render json:room
        end
        
    end

    def join
        room = Room.find(params[:id])
        if room && room.authenticate(params[:password])
            user_game = UserGame.create(user_id: params[:user_id], game: room.game)
            # serialized_data = ActiveModelSerializers::Adapter::Json.new(
            #     UserGameSerializer.new(user_game)
            # ).serializable_hash
            # RoomsChannel.broadcast_to room, serialized_data
            RoomsChannel.broadcast_to room, message: true
            render json: room
        else
            render json: {errors: "You dun goofed!"}
        end
    end

    private def room_params
        params.require(:room).permit(:name, :password, :user_id)
    end
end
