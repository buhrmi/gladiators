class ArenaChannel < ApplicationCable::Channel
  def subscribed
    stream_from "arena:public"
  end

  def unsubscribed
  end
end
