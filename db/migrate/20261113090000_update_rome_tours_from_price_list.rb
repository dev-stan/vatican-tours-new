# Brings the Rome tours in line with the "ALL TOURS BY NUMBER and PRICES BY REGION - Rome prices" sheet: tour codes
# 201–212, titles, transport, accessibility tags, which kinds each tour sells, and prices.
#
# - Private prices are per party size (1–8 guests), one "Private, N guests" ticket per size, like the Sicily tours.
# - Group prices are per adult. Only the Adult ticket is set; Child and Infant tickets are left for the admin.
# - Private-only tours lose their group tickets and their unbooked group departures.
# - The sheet's accessibility column ("Wheelchairs", "Kids Friendly", "none") decides the wheelchair and with_kids
#   tags; other tags (e.g. active) are kept.
# - 207 "Rome All the Sights with English Speaking Driver" is new: its content and photos are copied from 206.
# - "On the Path of Angels and Demons Tour" isn't on the sheet: it's unpublished and loses its code.
#
# Tours are found by slug; a tour whose slug differs between environments lists every known slug (first match wins). The data is frozen here, so later edits to db/seeds/tours.yml can't change this migration.
class UpdateRomeToursFromPriceList < ActiveRecord::Migration[8.1]
  ACCESSIBILITY_TAGS = %w[wheelchair with_kids].freeze

  TOURS = [
    { code: 201, slug: "ancient-rome-walking-tour", title: "Ancient Rome Walking Tour", transport: "walking", tags: [],
      private: [ 360, 360, 360, 420, 420, 420, 480, 480 ], adult: 120 },
    { code: 202, slug: %w[ancient-rome-in-depth ancient-rome-in-depth-underground-colosseum], title: "Ancient Rome in Depth", transport: "walking", tags: [],
      private: [ 480, 480, 560, 560, 560, 560, 640, 640 ] },
    { code: 203, slug: "old-rome-walking-tour", title: "Old Rome Walking Tour", transport: "walking", tags: [],
      private: [ 360, 360, 420, 420, 420, 420, 480, 480 ], adult: 120 },
    { code: 204, slug: "old-rome-by-golf-cart", title: "Old Rome by Golf Cart", transport: "car", tags: %w[wheelchair],
      private: [ 380, 380, 380, 460, 460, 720, 720, 720 ] },
    { code: 205, slug: "rome-night-walk", title: "Night Walk", transport: "walking", tags: [],
      private: [ 240, 240, 280, 280, 280, 280, 320, 320 ], adult: 80 },
    { code: 206, slug: "rome-all-the-sights", title: "Rome, All the Sights Walking Tour", transport: "walking", tags: [],
      private: [ 720, 720, 960, 960, 960, 960, 1040, 1040 ], adult: 240 },
    { code: 207, slug: %w[english-speaking-driver-rome-tour rome-all-the-sights-with-driver], title: "Rome All the Sights with English Speaking Driver",
      transport: "car", tags: [], copy_from: "rome-all-the-sights",
      private: [ 1160, 1160, 1280, 1280, 1280, 1280, 1560, 1560 ] },
    { code: 208, slug: "appian-way-and-catacombs", title: "Appian Way and the Catacombs Tour", transport: "car", tags: [],
      private: [ 580, 580, 640, 640, 640, 640, 780, 780 ] },
    { code: 209, slug: "rome-baroque-walking-tour", title: "Rome Baroque Walking Tour", transport: "walking", tags: [],
      private: [ 360, 360, 420, 420, 420, 420, 480, 480 ], adult: 120 },
    { code: 210, slug: "jewish-rome-walking-tour", title: "Jewish Rome Walking Tour", transport: "walking", tags: [],
      private: [ 360, 360, 420, 420, 420, 420, 480, 480 ], adult: 120 },
    { code: 211, slug: "rome-underground-for-smart-kids", title: "Rome Underground for Smart Kids", transport: "car",
      tags: %w[with_kids], private: [ 360, 360, 420, 420, 420, 420, 480, 480 ] },
    { code: 212, slug: "rome-photography-tour", title: "Rome through the Lens with a Photographer", transport: "car", tags: [],
      private: [ 360, 360, 420, 420, 420, 420, 480, 480 ] }
  ].freeze

  RETIRED_SLUGS = %w[angels-and-demons-tour].freeze

  def up
    # Free the codes first: the retired tour and any tour outside this list must not hold a 2xx code.
    Tour.where(slug: RETIRED_SLUGS).find_each do |tour|
      tour.update!(code: nil, status: "draft")
      say "#{tour.title}: unpublished, code cleared"
    end
    found = TOURS.to_h { |data| [ data[:code], find_tour(data) ] }
    clashing = Tour.where(code: TOURS.pluck(:code)).where.not(id: found.values.compact.map(&:id))
    raise "Codes already used by other tours: #{clashing.pluck(:slug, :code).inspect}" if clashing.exists?

    TOURS.each do |data|
      tour = found[data[:code]]
      created = tour.nil?
      tour ||= data[:copy_from] ? copy_tour(data) : raise(ActiveRecord::RecordNotFound, "No tour with slug #{data[:slug].inspect}")

      tags = (tour.tags - ACCESSIBILITY_TAGS) + data[:tags]
      tour.update!(code: data[:code], title: data[:title], transport: data[:transport], tags:,
                   badge: (tour.badge if tags.include?(tour.badge)), region: "Rome")

      update_ticket_types(tour, data)
      sync_departures(tour, data, source: (Tour.find_by!(slug: data[:copy_from]) if created))
      say "#{data[:code]} #{tour.title}: updated"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Previous Rome prices aren't stored; restore from a backup"
  end

  private
    # Private: one ticket per party size. Group: Adult at the sheet price, other group tickets (Child, Infant)
    # untouched; tours without a group price lose all group tickets. Bookings keep their own copy of prices.
    def update_ticket_types(tour, data)
      kept = []
      position = 0

      if data[:adult]
        adult = tour.ticket_types.find_or_initialize_by(kind: "group", name: "Adult")
        adult.update!(min_age: 18, max_age: nil, max_guests: nil, price_cents: data[:adult] * 100, position: position)
        kept << adult.id
        tour.ticket_types.where(kind: "group").where.not(id: adult.id).order(:position, :id).each do |ticket|
          ticket.update!(position: position += 1)
          kept << ticket.id
        end
      end

      data[:private].each.with_index(1) do |price, guests|
        ticket = tour.ticket_types.find_or_initialize_by(kind: "private", name: "Private, #{guests} #{"guest".pluralize(guests)}")
        ticket.update!(min_age: nil, max_age: nil, max_guests: guests, price_cents: price * 100, position: position += 1)
        kept << ticket.id
      end

      tour.ticket_types.where.not(id: kept).delete_all
    end

    # Drops unbooked departures of a kind the tour no longer sells. A new tour gets its source's departure times.
    def sync_departures(tour, data, source:)
      kinds = data[:adult] ? %w[group private] : %w[private]
      tour.departures.where.not(kind: kinds).where.missing(:bookings).delete_all
      return unless source

      from = Date.current
      to = from + 8.weeks
      closed = (from.year..to.year).flat_map { |year| [ Date.new(year, 12, 25), Date.new(year, 1, 1) ] }
      times = source.departures.where(kind: "private").pluck(:starts_at).map { |time| time.in_time_zone.strftime("%H:%M") }.uniq.sort
      times = [ "09:00" ] if times.empty?
      created = Departures::Generator.call(tour:, kind: "private", times:, days: Departures::Generator::DAYS, capacity: 1,
                                           from:, to:, skip_dates: closed)
      say "#{tour.title}: #{created} departures created"
    end

    def find_tour(data)
      Array(data[:slug]).lazy.filter_map { |slug| Tour.find_by(slug:) }.first
    end

    # A new tour built from an existing one: same content, photos and meeting point, published.
    def copy_tour(data)
      source = Tour.find_by!(slug: data[:copy_from])
      tour = Tour.create!(
        **source.attributes.symbolize_keys.slice(:subtitle, :tagline, :finer_details, :region, :duration_minutes, :meeting_point,
                                                 :languages, :what_we_think, :what_customers_think, :customer_name, :customer_origin),
        slug: Array(data[:slug]).first, title: data[:title], transport: data[:transport], tags: [], status: "published"
      )
      source.highlights.each { |row| tour.highlights.create!(row.attributes.slice("title", "body", "position")) }
      source.inclusions.each { |row| tour.inclusions.create!(row.attributes.slice("label", "included", "position")) }
      source.tour_facts.each { |row| tour.tour_facts.create!(row.attributes.slice("label", "body", "position")) }
      tour.photos.attach(source.photos.map(&:blob))
      say "#{tour.title}: created from #{source.title}"
      tour
    end
end
