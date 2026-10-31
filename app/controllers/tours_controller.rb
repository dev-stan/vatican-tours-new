class ToursController < ApplicationController
  MORE_TOURS = 3

  def show
    @tour = Tour.published.with_attached_photos.includes(:highlights, :inclusions, :tour_facts, :ticket_types)
                .find_by!(slug: params[:slug])
    ticket_types = @tour.ticket_types.to_a
    # The booking card sells group tickets priced from an adult ticket, a private option, or both.
    @group_tickets = ticket_types.select(&:kind_group?)
    @group_tickets = [] unless @group_tickets.any?(&:adult?)
    @private_tickets = @tour.private_tickets
    if @group_tickets.any? || @private_tickets.any?
      @booking_options = booking_options(@tour, @group_tickets, @private_tickets)
    end
  end

  # Thank-you page after a booking. The token is the booking's signed id, see BookingsController.
  def booked
    @booking = Booking.includes(:departure, tour: [ :tour_facts, { photos_attachments: :blob } ])
                      .find_signed(params[:token], purpose: :confirmation)
    return redirect_to tour_path(params[:slug]) unless @booking&.tour&.slug == params[:slug]

    @tour = @booking.tour
    @departure = @booking.departure
    @more_tours = more_tours(@tour)
  end

  private
    # Everything the booking card needs: ticket prices per kind the tour sells and the bookable departures,
    # grouped by Rome date. Party-size checks against seats_left happen in the browser and again in Bookings::Create.
    # `guests` are the steppers: the group tickets, or a single "Guest" for a private-only tour.
    def booking_options(tour, group_tickets, private_tickets)
      departures = tour.departures.bookable.chronological.group_by(&:kind)
      guests = group_tickets.map { |ticket| { id: ticket.id, name: ticket.name, ages: ticket.age_label, price_cents: ticket.price_cents, adult: ticket.adult? } }
      guests = [ { id: 0, name: "Guest", ages: nil, price_cents: 0, adult: true } ] if guests.empty?

      options = { guests: guests }
      if group_tickets.any?
        options[:group] = {
          max_guests: departures.fetch("group", []).map(&:capacity).max || 1,
          departures: departure_days(departures["group"])
        }
      end
      if private_tickets.any?
        options[:private] = {
          tiers: private_tickets.map { |ticket| { ticket_id: ticket.id, max_guests: ticket.max_guests, price_cents: ticket.price_cents } },
          max_guests: private_tickets.last.max_guests,
          departures: departure_days(departures["private"])
        }
      end
      options
    end

    def departure_days(departures)
      Array(departures).group_by { |departure| departure.starts_at.to_date.iso8601 }.transform_values do |day|
        day.map { |departure| { id: departure.id, time: departure.starts_at.strftime("%-l:%M %p"), seats_left: departure.seats_left } }
      end
    end

    # Other tours in the same location first, then the rest of the catalogue.
    def more_tours(tour)
      Tour.published.where.not(id: tour.id).with_attached_photos.includes(:ticket_types)
          .in_order_of(:location, [ tour.location ], filter: false).order(:id).limit(MORE_TOURS)
    end
end
