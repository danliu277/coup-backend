class GamesChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    game = Game.find(params[:room])
    stream_for game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # debugger
  end
end
