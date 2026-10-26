class CreateTourFacts < ActiveRecord::Migration[8.1]
  def change
    create_table :tour_facts do |t|
      t.references :tour, null: false, foreign_key: true, index: false
      t.string :label, null: false
      t.text :body, null: false
      t.integer :position, null: false, default: 0
      t.timestamps

      t.index [ :tour_id, :position ]
    end
  end
end
