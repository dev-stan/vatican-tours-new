require "test_helper"

class AdminTest < ActionDispatch::IntegrationTest
  # The login from credentials, or admin / admin outside production, see config/initializers/avo.rb.
  LOGIN = Rails.application.credentials.admin&.slice(:username, :password).presence || { username: "admin", password: "admin" }
  AUTH = { "Authorization" => ActionController::HttpAuthentication::Basic.encode_credentials(LOGIN[:username], LOGIN[:password]) }

  test "the admin needs the password" do
    get "/admin/resources/bookings"
    assert_response :unauthorized

    get "/admin/resources/bookings", headers: { "Authorization" => ActionController::HttpAuthentication::Basic.encode_credentials("admin", "wrong") }
    assert_response :unauthorized
  end

  test "the admin opens on the bookings list" do
    get "/admin", headers: AUTH
    assert_redirected_to "/admin/resources/bookings"
  end

  test "every resource lists, shows and edits" do
    records = [ bookings(:confirmed), departures(:group_open), tours(:ancient_rome), ticket_types(:adult) ]
    records << tours(:ancient_rome).highlights.create!(title: "Palatine Hill")
    records << tours(:ancient_rome).inclusions.create!(label: "Licensed guide")
    records << tours(:ancient_rome).tour_facts.create!(label: "Bring ID", body: "Checked at the gate.")

    records.each do |record|
      base = "/admin/resources/#{record.model_name.route_key}"
      get base, headers: AUTH
      assert_response :success, "#{base} index"
      get "#{base}/#{record.to_param}", headers: AUTH
      assert_response :success, "#{base} show"
      get "#{base}/#{record.to_param}/edit", headers: AUTH
      assert_response :success, "#{base} edit"
    end
  end

  test "editing a booking preselects its departure and lists only the tour's upcoming ones" do
    booking = bookings(:confirmed)
    booking.update_column :departure_id, departures(:group_past).id

    get "/admin/resources/bookings/#{booking.id}/edit", headers: AUTH
    assert_response :success
    assert_select "select[name='booking[departure_id]']" do
      assert_select "option[selected][value='#{departures(:group_past).id}']"
      assert_select "option[value='#{departures(:group_open).id}']"
      assert_select "option[value='#{departures(:food_private_open).id}']", count: 0
    end
  end

  test "the manager cancels and restores a booking, and the seats follow" do
    booking = bookings(:confirmed)
    departure = departures(:group_nearly_full)

    patch "/admin/resources/bookings/#{booking.id}", headers: AUTH, params: { booking: { status: "cancelled", notes: "Never paid" } }
    assert_response :redirect
    assert booking.reload.cancelled?
    assert_equal "Never paid", booking.notes
    assert_equal 7, departure.reload.seats_booked

    patch "/admin/resources/bookings/#{booking.id}", headers: AUTH, params: { booking: { status: "confirmed" } }
    assert booking.reload.confirmed?
    assert_equal 10, departure.reload.seats_booked
  end

  test "prices are edited in euros and stored in cents" do
    ticket = ticket_types(:adult)
    patch "/admin/resources/ticket_types/#{ticket.id}", headers: AUTH, params: { ticket_type: { price_cents: "72.50" } }
    assert_response :redirect
    assert_equal 72_50, ticket.reload.price_cents
  end
end
