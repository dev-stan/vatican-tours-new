require "test_helper"

class ToursControllerTest < ActionDispatch::IntegrationTest
  test "tour page hands the booking card its tickets and bookable departures" do
    get tour_path(tours(:ancient_rome))
    assert_response :success

    options = JSON.parse(css_select("[data-controller=booking]").first["data-booking-options-value"])
    assert_equal [ "Age 18+", "Age 6–17", "Age 0–5" ], options["group"]["tickets"].map { |ticket| ticket["ages"] }
    assert_equal 390_00, options["private"]["price_cents"]

    departure_ids = options.values.flat_map { |kind| kind["departures"].values.flatten.map { |departure| departure["id"] } }
    assert_includes departure_ids, departures(:group_open).id
    assert_includes departure_ids, departures(:private_open).id
    assert_not_includes departure_ids, departures(:group_closed).id
    assert_not_includes departure_ids, departures(:group_tomorrow_within_cutoff).id
    assert_not_includes departure_ids, departures(:food_private_open).id
  end

  test "tour page shows the tour's own content" do
    tour = tours(:ancient_rome)
    tour.update!(tagline: "Two Thousand Years", description: "The pitch.\n\nFirst detail.\n\nSecond detail.")
    tour.highlights.create!(title: "Palatine Hill", body: "Where Rome began.")
    tour.inclusions.create!(label: "Licensed guide", included: true)
    tour.inclusions.create!(label: "Hotel pickup", included: false)
    tour.tour_facts.create!(label: "Bring ID", body: "Tickets are checked at the gate.")

    get tour_path(tour)

    assert_select "title", "Ancient Rome Walking Tour — Vatican Tours Inc"
    assert_select "h1", "Skip the Colosseum queue."
    assert_select "li", /Private or Group/
    assert_select "li", /Live guide in English/
    assert_select "h3", "Palatine Hill"
    assert_select "h2", "Two Thousand Years"
    assert_select "p", "The pitch."
    assert_select "#details-heading ~ div p", 2
    assert_select "li", /Included: Licensed guide/
    assert_select "li", /Not included: Hotel pickup/
    assert_select "dt", "Bring ID"
  end

  test "tours the booking card can't sell yet show no booking card" do
    # Private only: the card needs group tickets with an adult price too.
    get tour_path(tours(:food_tour))

    assert_response :success
    assert_select "[data-controller=booking]", 0
    assert_select "aside", 0
    # Sections without content are left out.
    assert_select "#highlights-heading", 0
    assert_select "#details-heading", 0
  end

  test "unknown and draft tours are not found" do
    get tour_path("no-such-tour")
    assert_response :not_found

    get tour_path(tours(:draft_tour))
    assert_response :not_found
  end

  test "thank-you page shows the booking" do
    booking = bookings(:confirmed)
    get booked_tour_path(booking.tour, booking.signed_id(purpose: :confirmation))

    assert_response :success
    assert_match booking.reference, response.body
    assert_match "2 adults and 1 child", response.body
    assert_match "€175", response.body
    assert_select "#ticket-heading a[href=?]", tour_path(booking.tour), text: booking.tour.title
  end

  test "thank-you page follows the booking status" do
    booking = bookings(:confirmed)
    path = booked_tour_path(booking.tour, booking.signed_id(purpose: :confirmation))

    booking.pending!
    get path
    assert_select "title", /Booking Request Received/
    assert_match "Not yet confirmed", response.body
    assert_match "within 12 hours", response.body
    assert_select "span", "Awaiting confirmation"

    booking.confirmed!
    get path
    assert_select "title", /Booking Confirmed/
    assert_select "span", "Confirmed"
    assert_select "h3", "Place confirmed"
    assert_no_match "within 12 hours", response.body

    booking.cancelled!
    get path
    assert_select "title", /Booking Cancelled/
    assert_select "span", "Cancelled"
    assert_select "a[href=?]", tour_path(booking.tour), text: "Choose another date"
    assert_select "#status-heading", 0
  end

  test "thank-you page needs a valid token for that tour" do
    booking = bookings(:confirmed)

    get booked_tour_path(booking.tour, booking.reference)
    assert_redirected_to tour_path(booking.tour)

    get booked_tour_path(booking.tour, booking.signed_id(purpose: :other))
    assert_redirected_to tour_path(booking.tour)

    get booked_tour_path(tours(:food_tour), booking.signed_id(purpose: :confirmation))
    assert_redirected_to tour_path(tours(:food_tour))
  end
end
