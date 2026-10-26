class Avo::Resources::Tour < Avo::BaseResource
  self.title = :title
  self.icon = "tabler/outline/map"
  self.attachments = [ :photos ]
  self.search = {
    query: -> { query.where("tours.title LIKE :q OR tours.slug LIKE :q OR tours.location LIKE :q", q: "%#{q}%") }
  }
  # Tours use their slug in URLs (Tour#to_param).
  self.find_record_method = -> {
    id.is_a?(Array) ? query.where(slug: id) : query.find_by!(slug: id)
  }
  self.external_link = -> { main_app.tour_path(record) if record.published? }

  def fields
    field :title, as: :text, link_to_record: true
    field :status, as: :select, options: ::Tour.statuses.keys.index_by(&:humanize), format_display_using: -> { value.to_s.humanize },
          help: "Only published tours appear on the site."
    field :slug, as: :text, hide_on: :index, help: "The tour's web address: /tours/<slug>. Changing it breaks old links."
    field :location, as: :select, options: PagesController::LOCATIONS.excluding("All Locations").index_by(&:itself)
    field :duration_minutes, as: :number, name: "Duration (minutes)"
    field :headline, as: :text, hide_on: :index
    field :tagline, as: :text, hide_on: :index
    field :description, as: :textarea, hide_on: :index, help: "Leave a blank line between paragraphs."
    field :meeting_point, as: :text, hide_on: :index
    field :languages, as: :select, multiple: true, hide_on: :index,
          options: ToursHelper::LANGUAGE_NAMES.invert.slice(*ToursHelper::LANGUAGE_NAMES.values_at(*::Tour::LANGUAGES))
    field :tags, as: :select, multiple: true, hide_on: :index,
          options: ::Tour::TAGS.index_by { |tag| ToursHelper::TAG_CATEGORIES.fetch(tag, tag.humanize) }
    field :photos, as: :files, hide_on: :index, help: "The first photo is the tour's main image."

    field :ticket_types, as: :has_many
    field :departures, as: :has_many
    field :highlights, as: :has_many
    field :inclusions, as: :has_many
    field :tour_facts, as: :has_many, name: "Good to know"
    field :bookings, as: :has_many
  end
end
