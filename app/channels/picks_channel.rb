class PicksChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'picks'
  end
end
