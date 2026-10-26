class AddTaglineToTours < ActiveRecord::Migration[8.1]
  def change
    add_column :tours, :tagline, :string
  end
end
