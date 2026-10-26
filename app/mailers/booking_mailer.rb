class BookingMailer < ApplicationMailer
  # Set with: bin/rails credentials:edit
  #   agency:
  #     email: bookings@...
  def self.agency_email
    Rails.application.credentials.dig(:agency, :email).presence ||
      (Rails.env.production? ? raise("Missing credentials agency.email") : "agency@vaticantours.example")
  end

  # Not a confirmation: the agency confirms each request by hand and sends payment details.
  def request_received(booking)
    load_booking(booking)
    mail to: email_address_with_name(@booking.email, @booking.name),
         subject: "We’ve received your booking request – #{@tour.title} (#{@booking.reference})"
  end

  def agency_notification(booking)
    load_booking(booking)
    mail to: self.class.agency_email, reply_to: email_address_with_name(@booking.email, @booking.name),
         subject: "New booking request #{@booking.reference} – #{@departure.starts_at.to_fs(:tour_short)} – " \
                  "#{@booking.guests} #{"guest".pluralize(@booking.guests)}"
  end

  private
    def load_booking(booking)
      @booking = booking
      @departure = booking.departure
      @tour = booking.tour
      @status_url = booked_tour_url(@tour, booking.signed_id(purpose: :confirmation))
      @admin_url = Avo::Engine.routes.url_helpers.resources_booking_url(booking, **default_url_options)
    end
end
