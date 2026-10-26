class CreateTicketTypes < ActiveRecord::Migration[8.1]
  def change
    create_table :ticket_types do |t|
      t.references :tour, null: false, foreign_key: true, index: false
      t.string :kind, null: false
      t.string :name, null: false
      t.integer :min_age
      t.integer :max_age
      # Party size limit for a private ticket; nil means no limit.
      t.integer :max_guests
      t.integer :price_cents, null: false, default: 0
      t.integer :position, null: false, default: 0
      t.timestamps

      t.index [ :tour_id, :kind, :position ]
      t.index [ :tour_id, :kind, :name ], unique: true
      t.check_constraint "kind IN ('group', 'private')", name: "ticket_types_kind_valid"
      t.check_constraint "price_cents >= 0", name: "ticket_types_price_non_negative"
      t.check_constraint "min_age IS NULL OR max_age IS NULL OR min_age <= max_age", name: "ticket_types_age_range"
      t.check_constraint "max_guests IS NULL OR max_guests > 0", name: "ticket_types_max_guests_positive"
    end
  end
end
