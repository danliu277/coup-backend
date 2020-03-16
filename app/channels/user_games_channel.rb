class UserGamesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    user_game = UserGame.find(params[:id])
    stream_for user_game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
