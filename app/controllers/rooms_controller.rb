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
        if room.save
            # game = Game.create(room: room)
            usergame = UserGame.create(room: room, user_id: room_params[:user_id])
            
            render json:room
        end
        
    end

    def join
        room = Room.find(params[:id])
        if room && room.authenticate(params[:password])
            UserGame.create(user_id: params[:user_id], room: room)
            render json: room
        else
            render json: {errors: "You dun goofed!"}
        end
    end

    private def room_params
        params.require(:room).permit(:name, :password, :user_id)
    end
end
