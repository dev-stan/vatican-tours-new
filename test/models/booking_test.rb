require "test_helper"

class BookingTest < ActiveSupport::TestCase
  def new_booking(**attributes)
    Booking.new({ tour: tours(:ancient_rome), departure: departures(:group_open), name: "Ann", email: "ann@example.com",
                  phone: "+1 555 0100", guests: 1, total_cents: 6500 }.merge(attributes))
  end

  test "assigns a VTI reference on create" do
    booking = new_booking
    booking.save!
    assert_match(/\AVTI-[2-9A-HJKMNP-Z]{4}\z/, booking.reference)
  end

  test "reference is unique" do
    booking = new_booking(reference: bookings(:confirmed).reference)
    assert_not booking.valid?
    assert_includes booking.errors[:reference], "has already been taken"
  end

  test "requires name and a valid email" do
    booking = new_booking(name: " ", email: "not-an-email")
    assert_not booking.valid?
    assert booking.errors[:name].any?
    assert booking.errors[:email].any?
  end

  test "normalizes email" do
    assert_equal "ann@example.com", new_booking(email: "  Ann@Example.COM ").email
  end

  test "requires a phone number" do
    booking = new_booking(phone: " ")
    assert_not booking.valid?
    assert booking.errors[:phone].any?
  end

  test "guests must be positive" do
    assert_not new_booking(guests: 0).valid?
  end

  test "departure must belong to the tour" do
    booking = new_booking(departure: departures(:food_private_open))
    assert_not booking.valid?
    assert_includes booking.errors[:departure], "must belong to the booked tour"
  end

  test "seats held: guests for group, the whole slot for private" do
    assert_equal 3, bookings(:confirmed).seats_held
    assert_equal 1, new_booking(departure: departures(:private_open), guests: 6).seats_held
  end

  test "new bookings are pending" do
    booking = new_booking
    booking.save!
    assert booking.pending?
  end

  test "saving a booking takes its seats" do
    new_booking(guests: 3).save!
    assert_equal 3, departures(:group_open).reload.seats_booked
  end

  test "confirming keeps the seats; cancelling frees them; restoring takes them again" do
    booking = bookings(:confirmed)
    departure = departures(:group_nearly_full)

    booking.pending!
    assert_equal 10, departure.reload.seats_booked
    booking.cancelled!
    assert_equal 7, departure.reload.seats_booked
    booking.confirmed!
    assert_equal 10, departure.reload.seats_booked
  end

  test "restoring a booking onto a full departure overbooks it" do
    booking = bookings(:confirmed)
    departure = departures(:group_nearly_full)
    booking.cancelled!
    departure.reload.update!(seats_booked: 12)

    booking.confirmed!
    assert_equal 15, departure.reload.seats_booked
    assert_equal 3, departure.overbooked_by
  end

  test "changing the party size moves the seat count" do
    bookings(:confirmed).update!(guests: 5)
    assert_equal 12, departures(:group_nearly_full).reload.seats_booked
  end

  test "editing other details leaves seats alone" do
    bookings(:confirmed).update!(notes: "Paid by PayPal", phone: "+39 333 0000000")
    assert_equal 10, departures(:group_nearly_full).reload.seats_booked
  end

  test "moving a booking to another departure moves its seats" do
    bookings(:confirmed).update!(departure: departures(:group_open))
    assert_equal 7, departures(:group_nearly_full).reload.seats_booked
    assert_equal 3, departures(:group_open).reload.seats_booked
  end

  test "deleting a booking frees its seats" do
    bookings(:confirmed).destroy!
    assert_equal 7, departures(:group_nearly_full).reload.seats_booked
  end

  test "a cancelled booking holds no seats" do
    booking = bookings(:confirmed)
    booking.status = "cancelled"
    assert_equal 0, booking.seats_held
  end

  test "ticket lines read back with indifferent keys" do
    assert_equal 2, bookings(:confirmed).ticket_lines.first[:quantity]
  end
end
