class GlobalChannel < ApplicationCable::Channel
  def subscribed
    if params[:sgid]
      @subject = GlobalID::Locator.locate_signed(params[:sgid])
      reject unless @subject
      @subject.try(:on_subscribed, self)
      stream_for @subject
    else
      stream_from "global:#{params[:subject]}"
    end
  end

  def unsubscribed
  end
end
