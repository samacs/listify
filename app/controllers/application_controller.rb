# Base application controller
class ApplicationController < ActionController::API
  include MailingManagement

  protected

  def current_user
    @current_user ||= User.find_by(id: payload.first['user_id'])
  end

  def authenticate_request!
    return invalid_authentication if
      !payload || !JsonWebToken.valid_payload(payload.first)

    invalid_authentication unless current_user
  end

  def invalid_authentication
    render json: { error: 'Invalid Request', status: 401 },
           status: :unauthorized
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
