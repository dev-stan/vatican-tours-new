class Avo::Resources::NewsletterArticle < Avo::BaseResource
  include Avo::PostResource
  self.icon = "tabler/outline/notebook"
  self.attachments = [ :hero_image, :tour_image ]

  def fields
    post_fields section: "the newsletter", path: "/newsletter"
    field :tour, as: :belongs_to, searchable: false, help: "The tour advertised at the end of the article (optional)."
    field :tour_image, as: :file, is_image: true, hide_on: :index, help: "The photo shown above the tour, e.g. the winery."
  end
end
