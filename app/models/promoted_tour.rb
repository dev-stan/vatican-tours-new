# A booking button under a blog post or travel tip, or a tour card at the bottom of a newsletter article.
class PromotedTour < ApplicationRecord
  belongs_to :post, polymorphic: true
  belongs_to :tour

  validates :position, numericality: { only_integer: true }

  def button_label = label.presence || "Book #{tour.title}"
end
