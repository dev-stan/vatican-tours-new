class Article < ApplicationRecord
  # The tour advertised under the post: its title, finer details and a "Learn more about the tour" button.
  belongs_to :tour, optional: true

  has_rich_text :body
  has_one_attached :hero_image
  # The photo shown above the tour promo.
  has_one_attached :tour_image

  enum :status, { draft: "draft", published: "published" }, validate: true

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }

  before_save -> { self.published_at ||= Time.current }, if: :published?

  # Published posts, newest first. A post dated in the future waits until then.
  scope :live, -> { published.where(published_at: ..Time.current).order(published_at: :desc, id: :desc) }

  def to_param = slug

  # The promoted tour, only while it's on sale.
  def promoted_tour
    tour if tour&.published?
  end
end
