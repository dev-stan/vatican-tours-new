require "test_helper"

class Bookings::CreateTest < ActiveSupport::TestCase
  include ActionMailer::TestHelper

  def book(departure: departures(:group_open), tickets: { ticket_types(:adult).id => 2, ticket_types(:child).id => 1 }, **options)
    Bookings::Create.call(departure: departure, tickets: tickets, name: "Ann Smith", email: "ann@example.com",
                          phone: "+1 555 0100", **options)
  end

  test "books seats, snapshots prices and totals the booking" do
    result = book(tickets: { ticket_types(:adult).id => 2, ticket_types(:child).id => 1, ticket_types(:infant).id => 1 })

    assert result.success?
    booking = result.booking.reload
    assert booking.pending?
    assert_equal 4, booking.guests
    assert_equal 2 * 65_00 + 45_00, booking.total_cents
    assert_equal [ [ "Adult", 2, 6500 ], [ "Child", 1, 4500 ], [ "Infant", 1, 0 ] ],
                 booking.ticket_lines.map { |line| line.values_at(:name, :quantity, :unit_price_cents) }
    assert_equal tours(:ancient_rome), booking.tour
    assert_equal 4, departures(:group_open).reload.seats_booked
  end

  test "price snapshot survives later price changes" do
    booking = book.booking
    ticket_types(:adult).update!(price_cents: 99_00)
    assert_equal 6500, booking.reload.ticket_lines.first[:unit_price_cents]
    assert_equal 17500, booking.total_cents
  end

  test "enqueues the customer request receipt and the agency notification" do
    assert_enqueued_emails 2 do
      @booking = book.booking
    end
    assert_enqueued_email_with BookingMailer, :request_received, args: [ @booking ]
    assert_enqueued_email_with BookingMailer, :agency_notification, args: [ @booking ]
  end

  test "refuses to overbook" do
    departure = departures(:group_nearly_full)
    result = nil
    assert_no_difference -> { Booking.count } do
      assert_no_enqueued_emails do
        result = book(departure: departure, tickets: { ticket_types(:adult).id => 3 })
      end
    end
    assert_equal :sold_out, result.error
    assert_equal 10, departure.reload.seats_booked

    assert book(departure: departure, tickets: { ticket_types(:adult).id => 2 }).success?
    assert_equal 12, departure.reload.seats_booked
  end

  test "refuses a closed departure" do
    result = book(departure: departures(:group_closed))
    assert_equal :closed, result.error
    assert_equal 0, departures(:group_closed).reload.seats_booked
  end

  test "refuses a past departure" do
    result = book(departure: departures(:group_past))
    assert_equal :too_late, result.error
    assert_equal 0, departures(:group_past).reload.seats_booked
  end

  test "refuses within 24 hours of the start" do
    assert_equal :too_late, book(departure: departures(:group_tomorrow_within_cutoff)).error
  end

  test "sees a departure closed after it was loaded" do
    departure = departures(:group_open)
    Departure.where(id: departure.id).update_all(status: "closed")
    assert_equal :closed, book(departure: departure).error
  end

  test "refuses tickets from another kind or tour" do
    assert_equal :invalid_tickets, book(tickets: { ticket_types(:private_group).id => 1 }).error
    assert_equal :invalid_tickets, book(tickets: { ticket_types(:draft_adult).id => 1 }).error
    assert_equal :invalid_tickets, book(tickets: { 0 => 1 }).error
    assert_equal :invalid_tickets, book(tickets: { ticket_types(:adult).id => 0 }).error
  end

  test "group bookings need an adult" do
    assert_equal :adult_required, book(tickets: { ticket_types(:child).id => 2 }).error
  end

  test "refuses bad contact details without taking seats" do
    result = book(email: "nope")
    assert_equal :invalid_contact, result.error
    assert_match "Email", result.message
    assert_equal 0, departures(:group_open).reload.seats_booked
  end

  test "private booking takes the whole slot at a flat price" do
    departure = departures(:private_open)
    result = book(departure: departure, tickets: { ticket_types(:private_group).id => 1 }, guests: 5)

    assert result.success?
    assert_equal 5, result.booking.guests
    assert_equal 390_00, result.booking.total_cents
    assert_equal 1, departure.reload.seats_booked

    assert_equal :sold_out, book(departure: departure, tickets: { ticket_types(:private_group).id => 1 }, guests: 2).error
  end

  test "private booking respects the party size limit and needs a party size" do
    departure = departures(:private_open)
    assert_equal :party_too_large, book(departure: departure, tickets: { ticket_types(:private_group).id => 1 }, guests: 9).error
    assert_equal :invalid_tickets, book(departure: departure, tickets: { ticket_types(:private_group).id => 1 }).error
    assert_equal :invalid_tickets, book(departure: departure, tickets: { ticket_types(:private_group).id => 2 }, guests: 4).error
  end

  test "private booking priced by party size pays the price for its party" do
    tour = tours(:ancient_rome)
    ticket_types(:private_group).destroy!
    tiers = [ 380_00, 400_00, 420_00 ].each.with_index(1).map do |price_cents, guests|
      tour.ticket_types.create!(kind: "private", name: "Private, #{guests} guests", max_guests: guests, price_cents:, position: 3 + guests)
    end

    # A party of 2 can't book the 1-guest price, nor the 3-guest one.
    assert_equal :party_too_large, book(departure: departures(:private_open), tickets: { tiers.first.id => 1 }, guests: 4).error
    assert_equal :invalid_tickets, book(departure: departures(:private_open), tickets: { tiers.first.id => 1 }, guests: 2).error
    assert_equal :invalid_tickets, book(departure: departures(:private_open), tickets: { tiers.last.id => 1 }, guests: 2).error

    result = book(departure: departures(:private_open), tickets: { tiers.second.id => 1 }, guests: 2)
    assert result.success?
    assert_equal 400_00, result.booking.total_cents
  end
end
