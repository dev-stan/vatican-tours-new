# A newsletter story at /newsletter/<slug>, ending with a promo for one tour.
class NewsletterArticle < ApplicationRecord
  include Publishable

  # The tour advertised under the post: its title, finer details and a "Learn more about the tour" button.
  belongs_to :tour, optional: true
  # The photo shown above the tour promo.
  has_one_attached :tour_image

  # The promoted tour, only while it's on sale.
  def promoted_tour
    tour if tour&.published?
  end
end
