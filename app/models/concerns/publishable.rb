# What every post type shares (newsletter articles, blog posts, travel tips): a rich-text story with a hero photo,
# reached by its slug, that goes live once published and its publish date has come.
module Publishable
  extend ActiveSupport::Concern

  included do
    has_rich_text :body
    has_one_attached :hero_image

    enum :status, { draft: "draft", published: "published" }, validate: true

    validates :title, presence: true
    validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }
    # Longer ones get cut off in search results.
    validates :meta_title, length: { maximum: 60 }
    validates :meta_description, length: { maximum: 155 }

    before_save -> { self.published_at ||= Time.current }, if: :published?

    # Published posts, newest first. A post dated in the future waits until then.
    scope :live, -> { published.where(published_at: ..Time.current).order(published_at: :desc, id: :desc) }
  end

  def to_param = slug

  def live? = published? && published_at.present? && published_at <= Time.current

  # The day the post last changed, if that's after the day it went out.
  def revised_on
    updated_at.to_date if published_at && updated_at.to_date > published_at.to_date
  end
end
