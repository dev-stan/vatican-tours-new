class TourFact < ApplicationRecord
  belongs_to :tour

  validates :label, :body, presence: true
  validates :position, numericality: { only_integer: true }
end
