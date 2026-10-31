class AddTransportToTours < ActiveRecord::Migration[8.1]
  def change
    add_column :tours, :transport, :string, default: "walking", null: false
    add_check_constraint :tours, "transport IN ('walking', 'boat', 'car')", name: "tours_transport_valid"
  end
end
