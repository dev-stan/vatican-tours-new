class Avo::Resources::Booking < Avo::BaseResource
  self.title = :reference
  self.description = "Booking requests from the site. Email the guest yourself, then set the status here: " \
                     "cancelling frees the seats, and the guest's booking page shows the new status."
  self.icon = "tabler/outline/ticket"
  self.includes = [ :tour, :departure ]
  self.default_sort_column = :created_at
  self.search = {
    query: -> { query.where("bookings.reference LIKE :q OR bookings.name LIKE :q OR bookings.email LIKE :q", q: "%#{q}%") }
  }
  # The guest's own booking page, as they see it.
  self.external_link = -> { main_app.booked_tour_path(record.tour, record.signed_id(purpose: :confirmation)) }

  def fields
    field :reference, as: :text, link_to_record: true, readonly: true, hide_on: :new
    field :status, as: :select, options: ::Booking.statuses.keys.index_by(&:humanize),
          format_display_using: -> { value.to_s.humanize },
          help: "Pending: waiting for you. Confirmed: you've emailed the confirmation and payment details. " \
                "Cancelled: frees the seats."
    field "Waiting", as: :text, only_on: :index do
      time_ago_in_words(record.created_at) if record.pending?
    end
    field :tour, as: :belongs_to
    # Avo lists at most 1000 records in the dropdown, and there are thousands of departures, so a booking's
    # own departure could fall off the list and show as unchosen. List only the tour's upcoming ones,
    # plus the booking's current departure even if it has passed.
    field :departure, as: :belongs_to,
          attach_scope: -> {
            scope = query.unscope(:order).reorder(:starts_at)
            scope = scope.where(tour_id: parent.tour_id) if parent.tour_id
            scope.where("departures.starts_at > ?", Time.current).or(scope.where(id: parent.departure_id))
          },
          help: "Moving the booking to another departure moves its seats too. The departure must belong to the tour."
    field :name, as: :text
    field :email, as: :text, copyable: true
    field :phone, as: :text, copyable: true
    field :guests, as: :number, help: "For a group departure, changing this changes the seats taken."
    field "Tickets", as: :textarea, only_on: :show do
      record.ticket_lines.map { |line| "#{line[:quantity]} × #{line[:name]} at €#{format("%.2f", line[:unit_price_cents] / 100.0)}" }.join("\n")
    end
    field :total_cents, as: :number, name: "Total (€)",
          format_using: -> { view.form? ? format("%.2f", value.to_i / 100.0) : number_to_currency(value.to_i / 100.0, unit: "€") },
          update_using: -> { (value.to_s.to_d * 100).round }
    field :notes, as: :textarea, hide_on: :index, help: "Only you see this. E.g. how and when the guest paid."
    field :created_at, as: :date_time, name: "Requested at", only_on: [ :index, :show ], sortable: true
  end

  def filters
    filter Avo::Filters::BookingStatus
  end
end
