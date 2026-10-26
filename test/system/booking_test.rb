require "application_system_test_case"

class BookingTest < ApplicationSystemTestCase
  include ActionMailer::TestHelper

  # Scoped to the card: the footer has a newsletter email field too.
  def fill_in_details
    within "aside" do
      click_on "Book Now"
      fill_in "Full name", with: "Ann Smith"
      fill_in "Email", with: "ann@example.com"
      fill_in "Phone", with: "+1 555 0100"
    end
  end

  test "booking a group tour from the tour page" do
    visit tour_path(tours(:ancient_rome))
    assert_no_field "Full name"
    fill_in_details

    assert_enqueued_emails 2 do
      click_on "Request Booking · €130"
      assert_text "Thank You"
    end

    booking = Booking.last
    assert_equal departures(:group_open), booking.departure
    assert_current_path booked_tour_path(booking.tour, booking.signed_id(purpose: :confirmation))
    assert_text booking.reference
    assert_text "2 adults"
  end

  test "a refusal from the server shows in the booking card" do
    visit tour_path(tours(:ancient_rome))
    fill_in_details
    departures(:group_open).update!(status: "closed")

    click_on "Request Booking · €130"
    assert_text "This departure is closed for booking."
    assert_current_path tour_path(tours(:ancient_rome))
    assert_button "Request Booking · €130"
  end

  test "times without room for the party are disabled" do
    visit tour_path(tours(:ancient_rome))
    find("button[aria-label='Add one adult']").click

    assert_button "9:00 AM"
    assert_button "10:30 AM Only 2 left", disabled: true
  end
end
