# Preview at http://localhost:3000/rails/mailers/booking_mailer (after creating a booking)
class BookingMailerPreview < ActionMailer::Preview
  def request_received
    BookingMailer.request_received(Booking.last!)
  end

  def agency_notification
    BookingMailer.agency_notification(Booking.last!)
  end
end
