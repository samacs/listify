module V1
  # Manages user creation and updates.
  class UsersController < ApplicationController
    before_action :authenticate_request!, only: %i[update me]
    before_action :set_user

    after_action :send_activation_email, only: :create

    def me
      render current_user
    end

    def create
      @user = User.new(user_params)
      if @user.save
        render @user
      else
        render_errors(@user.errors, :unprocessable_entity)
      end
    end

    def update
      if @user.update(user_params)
        render @user
      else
        render_errors(@user.errors, :unprocessable_entity)
      end
    end

    private

    def set_user
      @user = User.find_by(id: params[:id])
    end

    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password,
                                   :password_confirmation)
    end

    def send_activation_email
      activation_email if @user.persisted?
    end
  end
end
