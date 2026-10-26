class CreateDepartures < ActiveRecord::Migration[8.1]
  def change
    create_table :departures do |t|
      t.references :tour, null: false, foreign_key: true, index: false
      t.string :kind, null: false
      t.datetime :starts_at, null: false
      t.integer :capacity, null: false
      t.integer :seats_booked, null: false, default: 0
      t.string :status, null: false, default: "open"
      t.timestamps

      t.index [ :tour_id, :kind, :starts_at ], unique: true
      t.index :starts_at
      t.check_constraint "kind IN ('group', 'private')", name: "departures_kind_valid"
      t.check_constraint "status IN ('open', 'closed')", name: "departures_status_valid"
      # Last line of defence against overbooking.
      t.check_constraint "capacity > 0 AND seats_booked >= 0 AND seats_booked <= capacity", name: "departures_seats_within_capacity"
    end
  end
end
