# A travel tips guide at /travel-tips/<slug>: a pillar page, linked from the header.
class TravelTip < ApplicationRecord
  include Publishable
  include PromotesTours

  # Blog posts written in support of this guide. It lists them once they're live.
  has_many :blog_posts, dependent: :nullify
end
