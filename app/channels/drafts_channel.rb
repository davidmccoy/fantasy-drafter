class DraftsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'drafts_#{params[:draft]}'
  end
end
