class V1::NotesController < ApplicationController
  before_action :authenticate_request!
  before_action :set_list
  before_action :set_note, only: %i[update destroy show]

  def index
    @notes = @list.notes
  end

  def create
    @note = @list.notes.build(note_params)
    if @note.save
      ActionCable.server.broadcast "user_#{current_user.id}_notes",
                                   message: :note_created,
                                   note: @note
      render @note
    else
      render_errors(@note.errors, :unrpcoessable_entity)
    end
  end

  def update
    if @note.update(note_params)
      ActionCable.server.broadcast "user_#{current_user.id}_notes",
                                   message: :note_updated,
                                   note: @note
      render @note
    else
      render_errors(@note.errors, :unprocessable_entity)
    end
  end

  def destroy
    @note.destroy!
    ActionCable.server.broadcast "user_#{current_user.id}_notes",
                                 message: :note_destroyed,
                                 note: @note
    render @note
  end

  private

  def note_params
    params.require(:note).permit(:title, :content, :order)
  end

  def set_list
    @list = current_user.lists.find(params[:list_id])
  end

  def set_note
    @note = @list.notes.find(params[:id])
  end
end
