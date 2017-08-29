class V1::ListsController < ApplicationController
  before_action :authenticate_request!
  before_action :set_list, only: %i[update show destroy]

  def index
    @lists = current_user.lists
  end

  def create
    @list = current_user.lists.build(list_params)
    if @list.save
      ActionCable.server.broadcast "user_#{current_user.id}_lists",
                                   message: :list_created,
                                   list: @list
      render @list
    else
      render_error(@list.errors, :unprocessable_entity)
    end
  end

  def update
    if @list.update(list_params)
      ActionCable.server.broadcast "user_#{current_user.id}_lists",
                                   message: :list_updated,
                                   list: @list
      render @list
    else
      render_errors(@list.errors, :unprocessable_entity)
    end
  end

  def destroy
    @list.destroy!
    ActionCable.server.broadcast "user_#{current_user.id}_lists",
                                 message: :list_destroyed,
                                 list: @list
    render @list
  end

  private

  def set_list
    @list = current_user.lists.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :description, :order)
  end
end
