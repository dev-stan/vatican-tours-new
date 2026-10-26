class BookingsController < ApplicationController
  # Submitted by the tour page's booking card through Turbo. On success Turbo follows the redirect to
  # the thank-you page; a refusal is streamed into the card's error line.
  def create
    departure = Departure.joins(:tour).merge(Tour.published).find_by(id: booking_params[:departure_id])
    return refuse("Please choose a start time.") unless departure

    result = Bookings::Create.call(
      departure: departure, tickets: booking_params[:tickets] || {}, guests: booking_params[:guests],
      name: booking_params[:name], email: booking_params[:email], phone: booking_params[:phone]
    )

    if result.success?
      redirect_to confirmation_path(result.booking), status: :see_other
    else
      refuse(result.message)
    end
  end

  private
    def booking_params
      @booking_params ||= params.expect(booking: [ :departure_id, :guests, :name, :email, :phone, tickets: {} ])
    end

    def refuse(message)
      render turbo_stream: turbo_stream.update("booking-error", message), status: :unprocessable_entity
    end

    # Signed so the page, which shows the guest's name and email, can't be reached by guessing references.
    def confirmation_path(booking)
      booked_tour_path(booking.tour, booking.signed_id(purpose: :confirmation))
    end
end
