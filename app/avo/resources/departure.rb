class Avo::Resources::Departure < Avo::BaseResource
  self.title = -> { "#{record.tour.title} · #{record.starts_at.to_fs(:tour_short)} · #{record.kind.humanize}" }
  self.description = "Bookable start times. Generate many at once with bin/rails departures:generate."
  self.icon = "tabler/outline/calendar"
  self.includes = [ :tour ]
  self.default_sort_column = :starts_at
  self.default_sort_direction = :asc

  def fields
    field :tour, as: :belongs_to
    field :kind, as: :select, options: ::Departure.kinds.keys.index_by(&:humanize), format_display_using: -> { value.to_s.humanize }
    field :starts_at, as: :date_time, help: "Rome time.", sortable: true
    field :status, as: :select, options: ::Departure.statuses.keys.index_by(&:humanize), format_display_using: -> { value.to_s.humanize },
          help: "Closed departures can't be booked on the site."
    field :capacity, as: :number, help: "Seats for a group departure. A private departure is one slot: use 1."
    field :seats_booked, as: :number,
          help: "Kept up to date by bookings. Raise it by hand only to hold seats sold outside the site."
    field "Seats left", as: :number, only_on: [ :index, :show ] do
      record.seats_left
    end
    field "Overbooked by", as: :number, only_on: [ :index, :show ] do
      record.overbooked_by.nonzero?
    end
    field :bookings, as: :has_many
  end
end
