# What the newsletter, blog and travel tips admin screens share, so the three stay alike. Include it in the resource,
# then call post_fields in #fields and add the section's own fields after it.
module Avo::PostResource
  def self.included(resource)
    resource.title = :title
    resource.attachments = [ :hero_image ]
    resource.search = {
      query: -> { query.where("title LIKE :q OR slug LIKE :q", q: "%#{q}%") }
    }
    # Posts use their slug in URLs (Publishable#to_param).
    resource.find_record_method = -> {
      id.is_a?(Array) ? query.where(slug: id) : query.find_by!(slug: id)
    }
    resource.external_link = -> { main_app.polymorphic_path(record) if record.live? }
    resource.default_sort_column = :published_at
  end

  # section: what readers know it as, e.g. "the blog"; path: its address, e.g. "/blog".
  def post_fields(section:, path:)
    field :title, as: :text, link_to_record: true
    field :status, as: :select, options: model_class.statuses.keys.index_by(&:humanize), format_display_using: -> { value.to_s.humanize },
          help: "Only published posts appear in #{section}."
    field :published_at, as: :date_time, sortable: true, name: "Published",
          help: "Set automatically when first published. A future date keeps the post hidden until then."
    field :slug, as: :text, hide_on: :index, help: "The post's web address: #{path}/<slug>. Changing it breaks old links."
    field :excerpt, as: :textarea, hide_on: :index, help: "One or two sentences for the card on the #{path} page."
    field :meta_title, as: :text, hide_on: :index,
          help: "The title in Google results, up to 60 characters. Leave blank to use the title."
    field :meta_description, as: :textarea, hide_on: :index,
          help: "The snippet in Google results, up to 155 characters. Leave blank to use the excerpt."
    field :hero_image, as: :file, is_image: true, hide_on: :index, help: "The large photo behind the title."
    field :body, as: :trix, help: "The story. Headings, links, lists and inline photos are all fine."
  end
end
