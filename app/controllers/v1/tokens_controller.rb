module V1
  class TokensController < ApplicationController
    before_action :set_token, only: :destroy

    def create
      user = User.find_by(email: token_params[:email].to_s.downcase)
      if user && user.authenticate(token_params[:password])
        @token = JsonWebToken.encode(user_id: user.id,
                                     email: user.email)
        user.update(token: @token)
        render json: { token: @token, status: 201 }, status: :created
      else
        render json: { error: I18n.t('error.token.invalid_credentials'),
                       status: 401 },
               status: :unauthorized
      end
    end

    def destroy
      user.update(token: nil)
      head :no_content
    end

    private

    def set_token
    end

    def token_params
      params.require(:user).permit(:email, :password)
    end
  end
end
