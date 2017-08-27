# User model
class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :email,
            presence: true,
            uniqueness: true,
            email_format: { message: I18n.t('error.email.invalid') }
end
