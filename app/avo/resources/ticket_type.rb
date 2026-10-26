class Avo::Resources::TicketType < Avo::BaseResource
  self.title = -> { "#{record.name} (#{record.kind.humanize})" }
  self.icon = "tabler/outline/receipt"
  self.includes = [ :tour ]
  self.default_sort_column = :position
  self.default_sort_direction = :asc

  def fields
    field :tour, as: :belongs_to
    field :kind, as: :select, options: ::TicketType.kinds.keys.index_by(&:humanize), format_display_using: -> { value.to_s.humanize }
    field :name, as: :text
    field :price_cents, as: :number, name: "Price (€)",
          format_using: -> { view.form? ? format("%.2f", value.to_i / 100.0) : number_to_currency(value.to_i / 100.0, unit: "€") },
          update_using: -> { (value.to_s.to_d * 100).round },
          help: "Per person for group tickets, per group for a private ticket. Existing bookings keep the price they were booked at."
    field :min_age, as: :number, help: "18 or more makes it an adult ticket."
    field :max_age, as: :number
    field :max_guests, as: :number, help: "Private tickets: the largest party allowed."
    field :position, as: :number, help: "Lower numbers are listed first."
  end
end
