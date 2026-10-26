class CreateBookings < ActiveRecord::Migration[8.1]
  def change
    create_table :bookings do |t|
      t.references :tour, null: false, foreign_key: true
      t.references :departure, null: false, foreign_key: true
      t.string :reference, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone
      t.string :status, null: false, default: "confirmed"
      # Party size. A private booking takes the whole slot (1 seat) whatever its size.
      t.integer :guests, null: false
      t.integer :total_cents, null: false
      # Price snapshot: [{ ticket_type_id, name, quantity, unit_price_cents }]
      t.json :tickets, null: false, default: []
      t.timestamps

      t.index :reference, unique: true
      t.index :email
      t.check_constraint "status IN ('confirmed', 'cancelled')", name: "bookings_status_valid"
      t.check_constraint "guests > 0", name: "bookings_guests_positive"
      t.check_constraint "total_cents >= 0", name: "bookings_total_non_negative"
    end
  end
end
