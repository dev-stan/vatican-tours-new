class Inclusion < ApplicationRecord
  belongs_to :tour

  validates :label, presence: true
  validates :included, inclusion: { in: [ true, false ] }
  validates :position, numericality: { only_integer: true }
end
