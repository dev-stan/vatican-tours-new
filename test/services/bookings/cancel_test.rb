require "test_helper"

class Bookings::CancelTest < ActiveSupport::TestCase
  test "cancelling gives the seats back" do
    booking = bookings(:confirmed)
    assert Bookings::Cancel.call(booking)
    assert booking.reload.cancelled?
    assert_equal 7, departures(:group_nearly_full).reload.seats_booked
  end

  test "cancelling twice releases seats once" do
    booking = bookings(:confirmed)
    Bookings::Cancel.call(booking)
    assert_not Bookings::Cancel.call(Booking.find(booking.id))
    assert_equal 7, departures(:group_nearly_full).reload.seats_booked
  end

  test "cancelling a private booking frees the slot" do
    departure = departures(:private_open)
    booking = Bookings::Create.call(departure: departure, tickets: { ticket_types(:private_group).id => 1 }, guests: 4,
                                    name: "Ann", email: "ann@example.com", phone: "+1 555 0100").booking
    assert_equal 1, departure.reload.seats_booked

    Bookings::Cancel.call(booking)
    assert_equal 0, departure.reload.seats_booked
    assert departure.bookable?
  end
end
