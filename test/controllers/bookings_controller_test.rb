require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  def book(departure: departures(:group_open), tickets: { ticket_types(:adult).id => 2, ticket_types(:infant).id => 1 }, **fields)
    post bookings_path, as: :turbo_stream, params: {
      booking: { departure_id: departure&.id, tickets: tickets, name: "Ann Smith", email: "ann@example.com", phone: "+1 555 0100", **fields }
    }
  end

  test "creates the booking, sends both emails and redirects to the thank-you page" do
    assert_difference -> { Booking.count } do
      assert_enqueued_emails 2 do
        book
      end
    end

    booking = Booking.last
    assert_equal [ 3, 130_00 ], [ booking.guests, booking.total_cents ]
    assert_redirected_to booked_tour_path(booking.tour, booking.signed_id(purpose: :confirmation))
    assert_response :see_other
  end

  test "books a private departure for the party size" do
    book(departure: departures(:private_open), tickets: { ticket_types(:private_group).id => 1 }, guests: 5)

    assert_response :see_other
    assert_equal [ 5, 390_00 ], Booking.last.values_at(:guests, :total_cents)
  end

  test "streams the refusal into the booking card" do
    assert_no_difference -> { Booking.count } do
      book(departure: departures(:group_nearly_full), tickets: { ticket_types(:adult).id => 3 })
    end

    assert_response :unprocessable_entity
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_match %(target="booking-error"), response.body
    assert_match "not enough seats", response.body
  end

  test "requires a phone number" do
    assert_no_difference -> { Booking.count } do
      book(phone: "")
    end
    assert_response :unprocessable_entity
    assert_match "Phone can't be blank", response.body
  end

  test "refuses a missing departure or one on an unpublished tour" do
    book(departure: nil)
    assert_response :unprocessable_entity
    assert_match "Please choose a start time.", response.body

    book(departure: departures(:draft_group_open), tickets: { ticket_types(:draft_adult).id => 1 })
    assert_response :unprocessable_entity
    assert_match "Please choose a start time.", response.body
  end

  test "refuses a booking without tickets" do
    book(tickets: nil)
    assert_response :unprocessable_entity
    assert_equal "text/vnd.turbo-stream.html", response.media_type
  end
end
