# Notes model
class Note < ApplicationRecord
  include Sluggable

  default_scope -> { order(order: :desc) }

  slug_column(:title)

  belongs_to :list

  has_one :owner,
          through: :list

  validates :presence, presence: true
end
