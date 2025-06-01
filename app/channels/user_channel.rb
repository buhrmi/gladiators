class UserChannel < ApplicationCable::Channel
  def subscribed
    return reject unless current_user
    store("current_user").set current_user.as_json(User::PRIVATE_JSON_OPTIONS)
    stream_for current_user
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
