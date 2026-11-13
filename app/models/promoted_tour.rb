# A booking button under a blog post or travel tip.
class PromotedTour < ApplicationRecord
  belongs_to :post, polymorphic: true
  belongs_to :tour

  validates :position, numericality: { only_integer: true }

  def button_label = label.presence || "Book #{tour.title}"
end
