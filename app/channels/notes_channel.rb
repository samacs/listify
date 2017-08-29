class NotesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_#{current_user.id}_notes"
  end
end
