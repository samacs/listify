# User model
class User < ApplicationRecord
  has_secure_password

  has_many :lists,
           foreign_key: :owner_id,
           class_name: 'List'
  has_many :notes,
           through: :lists

  validates :name, presence: true
  validates :email,
            presence: true,
            email_format: { message: I18n.t('error.email.invalid') }

  before_save :downcase_email

  private

  def downcase_email
    email.downcase!
  end
end
