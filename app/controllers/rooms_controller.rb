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
            serialized_data = ActiveModelSerializers::Adapter::Json.new(
                RoomSerializer.new(room)
            ).serializable_hash
            ActionCable.server.broadcast 'rooms_channel', serialized_data
            head :ok
        end
    end

    private def room_params
        params.require(:room).permit(:name, :password, :user_id)
    end
end
