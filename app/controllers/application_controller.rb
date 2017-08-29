# Base application controller
class ApplicationController < ActionController::API
  include MailingManagement
  include AuthenticationManagement

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def render_errors(errors, status = :server_error)
    render json: { error: errors,
                   status: Rack::Utils::SYMBOL_TO_STATUS_CODE[status] },
           status: status
  end
  alias render_error :render_errors

  def record_not_found
    render_error 'Not Found', :not_found
  end
end
