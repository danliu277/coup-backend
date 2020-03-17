class RoomsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    room = Room.find(params[:room][:id])
    stream_for room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # Remove if user leaves room
    room = Room.find(params[:room][:id])
    user_game = room.user_games.find_by(user_id: params[:room][:user])
    user_game.destroy
    if room.user_games.length === 0
      room.destroy
    end
    RoomsChannel.broadcast_to room, message: true
  end
end
