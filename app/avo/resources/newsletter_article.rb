class Avo::Resources::NewsletterArticle < Avo::BaseResource
  include Avo::PostResource
  self.icon = "tabler/outline/notebook"
  self.attachments = [ :hero_image, :promo_image ]

  def fields
    post_fields section: "the newsletter", path: "/newsletter"
    # The promo box under the article: a tour, or a link with its own heading, text and button.
    field :tour, as: :belongs_to, searchable: false,
          help: "A tour to advertise at the end of the article. Leave blank to promote a link instead (below), or nothing."
    field :promo_url, as: :text, hide_on: :index, name: "Promo link",
          help: "Instead of a tour, promote any page: one of ours, e.g. /?region=tuscany, or a full https:// address."
    field :promo_title, as: :text, hide_on: :index, help: "The promo's heading. Required with a promo link."
    field :promo_text, as: :textarea, hide_on: :index, help: "A few sentences under the heading. A blank line starts a new paragraph."
    field :promo_button, as: :text, hide_on: :index, help: "The button's text. Leave blank for “Learn more”."
    field :promo_image, as: :file, is_image: true, hide_on: :index, help: "The photo at the top of the promo, e.g. the winery."
  end
end
