# A newsletter story at /newsletter/<slug>, ending with a callout box. The box advertises either a tour or any other page,
# ours (e.g. /?region=tuscany) or another site's, described by the promo_* fields. Never both. Any number of linked tours
# join it, each as a button named after the tour.
class NewsletterArticle < ApplicationRecord
  include Publishable
  include PromotesTours

  belongs_to :tour, optional: true
  # The photo shown at the top of the promo box.
  has_one_attached :promo_image

  # A path on this site or a full web address.
  validates :promo_url, format: { with: %r{\A(/|https?://)\S*\z}, message: "must start with / or http(s)://" },
                        allow_blank: true
  validates :promo_title, presence: true, if: -> { promo_url.present? }
  validate :promotes_one_thing

  # The promoted tour, only while it's on sale.
  def promoted_tour
    tour if tour&.published?
  end

  # Whether the box promotes a link rather than a tour.
  def promoted_link?
    tour.nil? && promo_url.present?
  end

  private

  def promotes_one_thing
    errors.add(:promo_url, "can't be set together with a tour: promote one or the other") if tour && promo_url.present?
  end
end
