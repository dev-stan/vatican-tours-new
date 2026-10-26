module Bookings
  # Books seats on a departure.
  #
  #   Bookings::Create.call(departure:, tickets: { adult.id => 2, child.id => 1 },
  #                         name:, email:, phone:)
  #
  # A private booking passes its single "Private group" ticket plus `guests:`, the party size.
  # Returns a Result; check `success?`, then use `booking`, or `error` and `message`.
  class Create
    MESSAGES = {
      closed: "This departure is closed for booking.",
      too_late: "Bookings close 24 hours before the start time.",
      sold_out: "There are not enough seats left on this departure.",
      invalid_tickets: "Please choose valid tickets for this departure.",
      adult_required: "Group bookings need at least one adult.",
      party_too_large: "This party is too large for the private tour.",
      invalid_contact: "Please check your contact details."
    }.freeze

    Result = Data.define(:booking, :error, :message) do
      def success? = error.nil?
    end

    class Refused < StandardError
      attr_reader :reason

      def initialize(reason, message = MESSAGES.fetch(reason))
        @reason = reason
        super(message)
      end
    end

    def self.call(...) = new(...).call

    def initialize(departure:, tickets:, name:, email:, phone: nil, guests: nil)
      @departure = departure
      @quantities = tickets.to_h.transform_keys(&:to_i).transform_values(&:to_i).reject { |_, qty| qty <= 0 }
      @contact = { name: name, email: email, phone: phone.presence }
      @private_party_size = guests.to_i
    end

    def call
      booking = Booking.transaction do
        # SQLite: the transaction opens as BEGIN IMMEDIATE, so this connection already holds the
        # database write lock and lock! just reloads fresh counts. On Postgres it is SELECT ... FOR UPDATE.
        @departure.lock!
        refuse!(:closed) if @departure.status_closed?
        refuse!(:too_late) if @departure.too_late_to_book?

        lines = ticket_lines
        guests = party_size(lines)
        seats = @departure.kind_private? ? 1 : guests
        refuse!(:sold_out) if seats > @departure.seats_left

        booking = Booking.new(@contact.merge(
          tour_id: @departure.tour_id, departure: @departure, guests: guests,
          tickets: lines, total_cents: lines.sum { |line| line["quantity"] * line["unit_price_cents"] }
        ))
        refuse!(:invalid_contact, booking.errors.full_messages.to_sentence) unless booking.valid?

        # Saving takes the seats, see Booking#move_seats.
        booking.save!
        booking
      end

      BookingMailer.request_received(booking).deliver_later
      BookingMailer.agency_notification(booking).deliver_later
      Result.new(booking: booking, error: nil, message: nil)
    rescue Refused => refusal
      Result.new(booking: nil, error: refusal.reason, message: refusal.message)
    end

    private
      def refuse!(...)
        raise Refused.new(...)
      end

      # Snapshot of the prices at booking time, so later price changes don't touch the booking.
      def ticket_lines
        refuse!(:invalid_tickets) if @quantities.empty? || ticket_types.size != @quantities.size

        ticket_types.map do |ticket_type|
          { "ticket_type_id" => ticket_type.id, "name" => ticket_type.name,
            "quantity" => @quantities.fetch(ticket_type.id), "unit_price_cents" => ticket_type.price_cents }
        end
      end

      # Only ticket types of this tour and this departure's kind count.
      def ticket_types
        @ticket_types ||= TicketType.where(id: @quantities.keys, tour_id: @departure.tour_id, kind: @departure.kind).ordered.to_a
      end

      def party_size(lines)
        if @departure.kind_private?
          refuse!(:invalid_tickets) unless lines.sum { |line| line["quantity"] } == 1 && @private_party_size.positive?
          max_guests = ticket_types.first.max_guests
          refuse!(:party_too_large) if max_guests && @private_party_size > max_guests
          @private_party_size
        else
          refuse!(:adult_required) unless ticket_types.any?(&:adult?)
          lines.sum { |line| line["quantity"] }
        end
      end
  end
end
