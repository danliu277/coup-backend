class RoomsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "rooms_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    # user = User.find(params[:user])
    # user.destroy
  end
end
