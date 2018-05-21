class DraftsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "draft_#{params[:draft]}"
  end

  def unsubscribed
  end
end
