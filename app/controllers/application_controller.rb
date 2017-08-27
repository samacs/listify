# Base application controller
class ApplicationController < ActionController::API
  include MailingManagement
  include Knock::Authenticable
end
