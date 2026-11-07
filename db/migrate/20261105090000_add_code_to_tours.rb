class AddCodeToTours < ActiveRecord::Migration[8.1]
  def change
    add_column :tours, :code, :integer
    add_index :tours, :code, unique: true
  end
end
