# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_10_26_075843) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "tour_id", null: false
    t.integer "departure_id", null: false
    t.string "reference", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "phone"
    t.string "status", default: "pending", null: false
    t.integer "guests", null: false
    t.integer "total_cents", null: false
    t.json "tickets", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index ["departure_id"], name: "index_bookings_on_departure_id"
    t.index ["email"], name: "index_bookings_on_email"
    t.index ["reference"], name: "index_bookings_on_reference", unique: true
    t.index ["tour_id"], name: "index_bookings_on_tour_id"
    t.check_constraint "guests > 0", name: "bookings_guests_positive"
    t.check_constraint "status IN ('pending', 'confirmed', 'cancelled')", name: "bookings_status_valid"
    t.check_constraint "total_cents >= 0", name: "bookings_total_non_negative"
  end

  create_table "departures", force: :cascade do |t|
    t.integer "tour_id", null: false
    t.string "kind", null: false
    t.datetime "starts_at", null: false
    t.integer "capacity", null: false
    t.integer "seats_booked", default: 0, null: false
    t.string "status", default: "open", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["starts_at"], name: "index_departures_on_starts_at"
    t.index ["tour_id", "kind", "starts_at"], name: "index_departures_on_tour_id_and_kind_and_starts_at", unique: true
    t.check_constraint "capacity > 0 AND seats_booked >= 0", name: "departures_seats_within_capacity"
    t.check_constraint "kind IN ('group', 'private')", name: "departures_kind_valid"
    t.check_constraint "status IN ('open', 'closed')", name: "departures_status_valid"
  end

  create_table "highlights", force: :cascade do |t|
    t.integer "tour_id", null: false
    t.string "title", null: false
    t.text "body"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tour_id", "position"], name: "index_highlights_on_tour_id_and_position"
  end

  create_table "inclusions", force: :cascade do |t|
    t.integer "tour_id", null: false
    t.string "label", null: false
    t.boolean "included", default: true, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tour_id", "position"], name: "index_inclusions_on_tour_id_and_position"
  end

  create_table "ticket_types", force: :cascade do |t|
    t.integer "tour_id", null: false
    t.string "kind", null: false
    t.string "name", null: false
    t.integer "min_age"
    t.integer "max_age"
    t.integer "max_guests"
    t.integer "price_cents", default: 0, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tour_id", "kind", "name"], name: "index_ticket_types_on_tour_id_and_kind_and_name", unique: true
    t.index ["tour_id", "kind", "position"], name: "index_ticket_types_on_tour_id_and_kind_and_position"
    t.check_constraint "kind IN ('group', 'private')", name: "ticket_types_kind_valid"
    t.check_constraint "max_guests IS NULL OR max_guests > 0", name: "ticket_types_max_guests_positive"
    t.check_constraint "min_age IS NULL OR max_age IS NULL OR min_age <= max_age", name: "ticket_types_age_range"
    t.check_constraint "price_cents >= 0", name: "ticket_types_price_non_negative"
  end

  create_table "tour_facts", force: :cascade do |t|
    t.integer "tour_id", null: false
    t.string "label", null: false
    t.text "body", null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tour_id", "position"], name: "index_tour_facts_on_tour_id_and_position"
  end

  create_table "tours", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.string "headline"
    t.text "description"
    t.string "location", null: false
    t.integer "duration_minutes", null: false
    t.string "meeting_point"
    t.json "languages", default: [], null: false
    t.json "tags", default: [], null: false
    t.string "status", default: "draft", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tagline"
    t.index ["slug"], name: "index_tours_on_slug", unique: true
    t.index ["status"], name: "index_tours_on_status"
    t.check_constraint "duration_minutes > 0", name: "tours_duration_positive"
    t.check_constraint "status IN ('draft', 'published')", name: "tours_status_valid"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "departures"
  add_foreign_key "bookings", "tours"
  add_foreign_key "departures", "tours"
  add_foreign_key "highlights", "tours"
  add_foreign_key "inclusions", "tours"
  add_foreign_key "ticket_types", "tours"
  add_foreign_key "tour_facts", "tours"
end
