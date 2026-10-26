class Highlight < ApplicationRecord
  belongs_to :tour

  validates :title, presence: true
  validates :position, numericality: { only_integer: true }
end
