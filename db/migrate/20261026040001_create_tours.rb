class CreateTours < ActiveRecord::Migration[8.1]
  def change
    # SQLite has no array type, so languages and tags are json arrays.
    create_table :tours do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.string :headline
      t.text :description
      t.string :location, null: false
      t.integer :duration_minutes, null: false
      t.string :meeting_point
      t.json :languages, null: false, default: []
      t.json :tags, null: false, default: []
      t.string :status, null: false, default: "draft"
      t.timestamps

      t.index :slug, unique: true
      t.index :status
      t.check_constraint "duration_minutes > 0", name: "tours_duration_positive"
      t.check_constraint "status IN ('draft', 'published')", name: "tours_status_valid"
    end
  end
end
