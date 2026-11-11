class Avo::Resources::Article < Avo::BaseResource
  self.title = :title
  self.icon = "tabler/outline/notebook"
  self.attachments = [ :hero_image, :tour_image ]
  self.search = {
    query: -> { query.where("articles.title LIKE :q OR articles.slug LIKE :q", q: "%#{q}%") }
  }
  # Articles use their slug in URLs (Article#to_param).
  self.find_record_method = -> {
    id.is_a?(Array) ? query.where(slug: id) : query.find_by!(slug: id)
  }
  self.external_link = -> { main_app.article_path(record) if record.published? }
  self.default_sort_column = :published_at

  def fields
    field :title, as: :text, link_to_record: true
    field :status, as: :select, options: ::Article.statuses.keys.index_by(&:humanize), format_display_using: -> { value.to_s.humanize },
          help: "Only published articles appear in the newsletter."
    field :published_at, as: :date_time, sortable: true, name: "Published",
          help: "Set automatically when first published. A future date keeps the article hidden until then."
    field :slug, as: :text, hide_on: :index, help: "The article's web address: /newsletter/<slug>. Changing it breaks old links."
    field :excerpt, as: :textarea, hide_on: :index, help: "One or two sentences for the card on the /newsletter page."
    field :hero_image, as: :file, is_image: true, hide_on: :index, help: "The large photo behind the title."
    field :body, as: :trix, help: "The story. Headings, links, lists and inline photos are all fine."
    field :tour, as: :belongs_to, searchable: false, help: "The tour advertised at the end of the article (optional)."
    field :tour_image, as: :file, is_image: true, hide_on: :index, help: "The photo shown above the tour, e.g. the winery."
  end
end
