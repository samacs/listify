# Lists model
class List < ApplicationRecord
  include Sluggable

  default_scope -> { order(order: :desc) }

  belongs_to :owner,
             foreign_key: :owner_id,
             class_name: 'User'

  has_many :notes,
           dependent: :destroy

  validates :name, presence: true

  def notes_count
    notes.count
  end
end
