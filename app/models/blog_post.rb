# A blog post at /blog/<slug>: an SEO article, linked from the footer, that points readers to a travel tips guide.
class BlogPost < ApplicationRecord
  include Publishable
  include PromotesTours

  belongs_to :travel_tip, optional: true

  # The guide this post links up to, only while it's live.
  def guide
    travel_tip if travel_tip&.live?
  end
end
