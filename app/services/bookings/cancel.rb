module Bookings
  # Cancels a booking; saving it gives its seats back to the departure (see Booking#move_seats).
  # Returns false if the booking was already cancelled.
  class Cancel
    def self.call(booking) = new(booking).call

    def initialize(booking)
      @booking = booking
    end

    def call
      Booking.transaction do
        @booking.lock!

        if @booking.cancelled?
          false
        else
          @booking.cancelled!
          true
        end
      end
    end
  end
end
