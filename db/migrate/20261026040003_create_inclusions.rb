class CreateInclusions < ActiveRecord::Migration[8.1]
  def change
    create_table :inclusions do |t|
      t.references :tour, null: false, foreign_key: true, index: false
      t.string :label, null: false
      t.boolean :included, null: false, default: true
      t.integer :position, null: false, default: 0
      t.timestamps

      t.index [ :tour_id, :position ]
    end
  end
end
