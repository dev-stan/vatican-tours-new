# Adds "train" as a transport mode (its own icon on the tour card) and sets it on the two Umbria
# tours that go by train from Rome: 601 (Highlights of Assisi) and 604 (Fun in Orvieto).
class AddTrainTransport < ActiveRecord::Migration[8.1]
  TRAIN_CODES = [ 601, 604 ].freeze

  class Tour < ActiveRecord::Base
    self.table_name = "tours"
  end

  def up
    remove_check_constraint :tours, name: "tours_transport_valid"
    add_check_constraint :tours, "transport IN ('walking', 'boat', 'car', 'train')", name: "tours_transport_valid"

    tours = Tour.where(code: TRAIN_CODES)
    missing = TRAIN_CODES - tours.pluck(:code)
    raise ActiveRecord::RecordNotFound, "No tours with codes #{missing.inspect}" if missing.any?

    tours.each do |tour|
      tour.update_columns(transport: "train", updated_at: Time.current)
      say "#{tour.code} #{tour.title}: train"
    end
  end

  def down
    Tour.where(transport: "train").update_all(transport: "car", updated_at: Time.current)
    remove_check_constraint :tours, name: "tours_transport_valid"
    add_check_constraint :tours, "transport IN ('walking', 'boat', 'car')", name: "tours_transport_valid"
  end
end
