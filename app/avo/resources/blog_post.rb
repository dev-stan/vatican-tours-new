class Avo::Resources::BlogPost < Avo::BaseResource
  include Avo::PostResource
  self.icon = "tabler/outline/article"

  def fields
    post_fields section: "the blog", path: "/blog"
    field :travel_tip, as: :belongs_to, name: "Travel tips guide", searchable: false,
          help: "The guide this post supports. The post links up to it, and the guide lists the post once it's live."
    field :promoted_tours, as: :has_many, name: "Booking buttons"
  end
end
