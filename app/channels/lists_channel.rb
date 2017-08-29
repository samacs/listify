class ListsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_#{current_user.id}_lists"
  end
end
