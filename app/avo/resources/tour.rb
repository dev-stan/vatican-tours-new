class Avo::Resources::Tour < Avo::BaseResource
  self.title = :title
  self.icon = "tabler/outline/map"
  self.attachments = [ :photos ]
  self.default_sort_column = :code
  self.default_sort_direction = :asc
  self.search = {
    query: -> {
      scope = query.where("tours.title LIKE :q OR tours.slug LIKE :q OR tours.region LIKE :q", q: "%#{q}%")
      q.strip.match?(/\A\d+\z/) ? scope.or(query.where(code: q.strip.to_i)) : scope
    }
  }
  # Tours use their slug in URLs (Tour#to_param).
  self.find_record_method = -> {
    id.is_a?(Array) ? query.where(slug: id) : query.find_by!(slug: id)
  }
  self.external_link = -> { main_app.tour_path(record) if record.published? }

  def fields
    field :code, as: :number, name: "ID", sortable: true, help: "The tour's ID. Vatican tours are 100+."
    field :title, as: :text, link_to_record: true
    field :status, as: :select, options: ::Tour.statuses.keys.index_by(&:humanize), format_display_using: -> { value.to_s.humanize },
          help: "Only published tours appear on the site."
    field :slug, as: :text, hide_on: :index, help: "The tour's web address: /tours/<slug>. Changing it breaks old links."
    field :region, as: :select, options: PagesController::REGIONS.excluding("All Regions").index_by(&:itself)
    field :duration_minutes, as: :number, name: "Duration (minutes)"
    field :subtitle, as: :text, hide_on: :index
    field :tagline, as: :text, hide_on: :index
    field :what_we_think, as: :textarea, hide_on: :index, help: "Our take on the tour, shown in the orange card on the tour page."
    field :what_customers_think, as: :textarea, hide_on: :index, help: "A traveller quote for the same card. Leave out the quotation marks."
    field :customer_name, as: :text, hide_on: :index, help: "Who said it, e.g. Betty & Peter."
    field :customer_origin, as: :text, hide_on: :index, help: "Where they are from, e.g. London, UK."
    field :finer_details, as: :textarea, hide_on: :index, help: "Shown under \"The Finer Details\". Leave a blank line between paragraphs."
    field :meeting_point, as: :text, hide_on: :index
    field :languages, as: :select, multiple: true, hide_on: :index,
          options: ToursHelper::LANGUAGE_NAMES.invert.slice(*ToursHelper::LANGUAGE_NAMES.values_at(*::Tour::LANGUAGES))
    field :badge, as: :select, include_blank: true, hide_on: :index, help: "Pill shown on the tour card photo. Must also be ticked in Tags.",
          options: ::Tour.badges.keys.index_by { |badge| ToursHelper::BADGE_LABELS.fetch(badge, badge.humanize) }
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
