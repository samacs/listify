# Helper methods for sending email.
module MailingManagement
  extend ActiveSupport::Concern

  protected

  def activation_email
    logger.debug "Sending activation email to #{@user.email}"
  end
end
