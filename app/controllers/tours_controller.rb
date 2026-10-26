class ToursController < ApplicationController
  MORE_TOURS = 3

  def show
    @tour = Tour.published.with_attached_photos.includes(:highlights, :inclusions, :tour_facts, :ticket_types)
                .find_by!(slug: params[:slug])
    ticket_types = @tour.ticket_types.to_a
    @group_tickets = ticket_types.select(&:kind_group?)
    @private_ticket = ticket_types.find(&:kind_private?)
    # The booking card sells group tickets priced from an adult ticket, and a private option. Tours
    # without both get an enquiry card instead.
    if @private_ticket && @group_tickets.any?(&:adult?)
      @booking_options = booking_options(@tour, @group_tickets, @private_ticket)
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
    # Everything the booking card needs: ticket prices per kind and the bookable departures,
    # grouped by Rome date. Party-size checks against seats_left happen in the browser and again in Bookings::Create.
    def booking_options(tour, group_tickets, private_ticket)
      departures = tour.departures.bookable.chronological.group_by(&:kind)

      {
        group: {
          tickets: group_tickets.map { |ticket| { id: ticket.id, ages: ticket.age_label, price_cents: ticket.price_cents, adult: ticket.adult? } },
          max_guests: departures.fetch("group", []).map(&:capacity).max || 1,
          departures: departure_days(departures["group"])
        },
        private: {
          ticket_id: private_ticket.id,
          price_cents: private_ticket.price_cents,
          max_guests: private_ticket.max_guests,
          departures: departure_days(departures["private"])
        }
      }
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
