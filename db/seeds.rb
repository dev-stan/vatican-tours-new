# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

CANCELLATION = "Full refund if you cancel at least 24 hours before your start time."
CLOSED_DAYS = ->(from, to) { (from.year..to.year).flat_map { |year| [ Date.new(year, 12, 25), Date.new(year, 1, 1) ] } }

# Photos are replaced only when the list in tours.yml changes, so re-seeding doesn't re-upload them.
def attach_photos(tour, files)
  return if tour.photos.map { |photo| photo.filename.to_s } == files

  tour.photos.purge
  files.each do |file|
    path = Rails.root.join("app/assets/images/tours", file)
    tour.photos.attach(io: path.open, filename: file, content_type: "image/webp")
  end
end

from = Date.current
to = from + 8.weeks

YAML.load_file(Rails.root.join("db/seeds/tours.yml")).each do |data|
  tour = Tour.find_or_initialize_by(slug: data["slug"])
  tour.update!(
    **data.slice("title", "tagline", "headline", "location", "transport", "meeting_point", "languages", "tags").symbolize_keys,
    badge: data["badge"],
    description: data["description"].strip,
    duration_minutes: (data["hours"] * 60).to_i,
    status: "published"
  )

  # Content blocks are replaced wholesale so re-running the seeds never duplicates them.
  tour.highlights.delete_all
  data["highlights"].each_with_index { |(title, body), position| tour.highlights.create!(title:, body:, position:) }

  tour.inclusions.delete_all
  inclusions = data["included"].map { |label| [ label, true ] } + data["excluded"].map { |label| [ label, false ] }
  inclusions.each_with_index { |(label, included), position| tour.inclusions.create!(label:, included:, position:) }

  tour.tour_facts.delete_all
  data["facts"].merge("Cancellation" => CANCELLATION)
               .each_with_index { |(label, body), position| tour.tour_facts.create!(label:, body:, position:) }

  # Ticket types are updated in place: bookings snapshot their prices, but keep ids stable anyway.
  prices = data["prices"]
  tickets = []
  if prices["adult"]
    tickets << { kind: "group", name: "Adult", min_age: 18, max_age: nil, max_guests: nil, price_cents: prices["adult"] * 100 }
    tickets << { kind: "group", name: "Child", min_age: 6, max_age: 17, max_guests: nil, price_cents: prices["child"] * 100 }
    tickets << { kind: "group", name: "Infant", min_age: 0, max_age: 5, max_guests: nil, price_cents: 0 }
  end
  case prices["private"]
  when Array # One private ticket per party size.
    prices["private"].each.with_index(1) do |price, guests|
      tickets << { kind: "private", name: "Private, #{guests} #{"guest".pluralize(guests)}", min_age: nil, max_age: nil, max_guests: guests, price_cents: price * 100 }
    end
  when Integer
    tickets << { kind: "private", name: "Private group", min_age: nil, max_age: nil, max_guests: prices["max_guests"], price_cents: prices["private"] * 100 }
  end

  kept = tickets.each_with_index.map do |attributes, position|
    ticket = tour.ticket_types.find_or_initialize_by(kind: attributes[:kind], name: attributes[:name])
    ticket.update!(attributes.merge(position: position))
    ticket.id
  end
  # Bookings keep their own copy of ticket prices, so dropped ticket types can go.
  tour.ticket_types.where.not(id: kept).delete_all

  attach_photos(tour, data.fetch("photos", []))

  # Departures only for the kinds the tour sells; unbooked ones of a kind it no longer sells go.
  kinds = tickets.map { |ticket| ticket[:kind] }.uniq
  tour.departures.where.not(kind: kinds).where.missing(:bookings).delete_all

  days = data.fetch("days", Departures::Generator::DAYS).map(&:to_sym)
  created = { "group" => data.fetch("capacity", 12), "private" => 1 }.slice(*kinds).sum do |kind, capacity|
    Departures::Generator.call(tour:, kind:, times: data["times"], days:, capacity:, from:, to:,
                               skip_dates: CLOSED_DAYS.(from, to))
  end
  puts "#{tour.title}: #{created} departures created"
end
