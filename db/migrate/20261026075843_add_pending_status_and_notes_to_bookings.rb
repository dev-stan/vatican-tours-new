class AddPendingStatusAndNotesToBookings < ActiveRecord::Migration[8.1]
  def change
    # New bookings are requests until the manager confirms them.
    change_column_default :bookings, :status, from: "confirmed", to: "pending"
    remove_check_constraint :bookings, "status IN ('confirmed', 'cancelled')", name: "bookings_status_valid"
    add_check_constraint :bookings, "status IN ('pending', 'confirmed', 'cancelled')", name: "bookings_status_valid"

    add_column :bookings, :notes, :text

    # The manager may restore a cancelled booking onto a full departure, so seats can exceed capacity.
    # Bookings::Create still refuses to sell more seats than are left.
    remove_check_constraint :departures, "capacity > 0 AND seats_booked >= 0 AND seats_booked <= capacity", name: "departures_seats_within_capacity"
    add_check_constraint :departures, "capacity > 0 AND seats_booked >= 0", name: "departures_seats_within_capacity"
  end
end
