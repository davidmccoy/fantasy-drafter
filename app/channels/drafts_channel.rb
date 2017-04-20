class DraftsChannel < ApplicationCable::Channel
  def subscribed
    # draft = Draft.find(params[:draft])
    stream_from "draft_#{params[:draft]}"
  end
end
