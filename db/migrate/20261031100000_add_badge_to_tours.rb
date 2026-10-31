class AddBadgeToTours < ActiveRecord::Migration[8.1]
  def change
    add_column :tours, :badge, :string
    add_check_constraint :tours, "badge IS NULL OR badge IN ('wheelchair', 'cruise', 'food', 'wine', 'active')", name: "tours_badge_valid"
  end
end
