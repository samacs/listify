module AuthenticationManagement
  extend ActiveSupport::Concern

  included do
    rescue_from Error::NotAuthorized, with: :invalid_authentication

    helper_method :current_user
  end

  protected

  def current_user
    @current_user ||= User.find_by(id: payload.first['user_id'])
  end

  def authenticate_request!
    raise Error::NotAuthorized unless
      payload &&
      JsonWebToken.valid_payload(payload.first) &&
      current_user
  end

  def invalid_authentication
    render_error 'Unauthorized', :unauthorized
  end

  private

  def payload
    authorization = request.headers['Authorization']
    token = authorization.split(' ').last
    JsonWebToken.decode(token)
  rescue
    nil
  end
end
