module Sluggable
  extend ActiveSupport::Concern

  included do
    attr_accessor :slug_column

    scope :by_slug, ->(slug) { where(slug: slug) }

    validates :slug, presence: true, length: { maximum: 128 }

    before_validation :validate_slug, on: %i[create update]

    after_validation :delete_slug_errors

    def to_param
      slug
    end

    def slug_column
      self.class.sluggable_column || :name
    end
  end

  module ClassMethods
    attr_reader :sluggable_column

    def slug_column(column)
      @sluggable_column = column
    end
  end

  private

  def validate_slug
    logger.debug slug_column
    self.slug = qualify_slug(self[slug_column].parameterize) if
      self[slug_column].present? && slug.blank?
  end

  def qualify_slug(base_slug)
    tentative_slug = base_slug
    while duplicate_slug?(tentative_slug)
      tentative_slug = generate_slug(base_slug)
    end
    tentative_slug
  end

  def duplicate_slug?(slug)
    self.class.where.not(id: id).by_slug(slug).exists?
  end

  def generate_slug(slug)
    "#{slug}-#{SecureRandom.random_number(10_000)}"
  end

  def delete_slug_errors
    errors.delete(:slug)
  end
end
