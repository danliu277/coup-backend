class RoomsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    room = Room.find(params[:room][:id])
    stream_for room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # Remove if user leaves room
    user_game = UserGame.find_by(user_id: params[:room][:user], room_id: params[:room][:id])
    user_game.destroy
  end
end
