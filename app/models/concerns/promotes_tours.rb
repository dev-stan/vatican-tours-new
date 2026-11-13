# Booking buttons under a post: tours picked in the admin, in order.
module PromotesTours
  extend ActiveSupport::Concern

  included do
    has_many :promoted_tours, -> { order(:position, :id) }, as: :post, dependent: :destroy, inverse_of: :post
  end

  # Only tours that are on sale get a button.
  def bookable_promotions
    promoted_tours.select { |promotion| promotion.tour&.published? }
  end
end
