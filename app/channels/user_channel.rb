class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_from "visitors-#{User.first.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
