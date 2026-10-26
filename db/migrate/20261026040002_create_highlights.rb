class CreateHighlights < ActiveRecord::Migration[8.1]
  def change
    create_table :highlights do |t|
      t.references :tour, null: false, foreign_key: true, index: false
      t.string :title, null: false
      t.text :body
      t.integer :position, null: false, default: 0
      t.timestamps

      t.index [ :tour_id, :position ]
    end
  end
end
