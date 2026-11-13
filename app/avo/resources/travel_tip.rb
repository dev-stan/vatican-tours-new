class Avo::Resources::TravelTip < Avo::BaseResource
  include Avo::PostResource
  self.icon = "tabler/outline/compass"

  def fields
    post_fields section: "Travel Tips", path: "/travel-tips"
    field :promoted_tours, as: :has_many, name: "Booking buttons"
    field :blog_posts, as: :has_many, help: "Listed under the guide once they're live."
  end
end
