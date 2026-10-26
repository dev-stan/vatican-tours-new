class TicketType < ApplicationRecord
  ADULT_AGE = 18

  belongs_to :tour

  # Prefixed because an unprefixed enum would define TicketType.private.
  enum :kind, { group: "group", private: "private" }, prefix: true, validate: true

  validates :name, presence: true, uniqueness: { scope: [ :tour_id, :kind ] }
  validates :price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :min_age, :max_age, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :max_guests, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :position, numericality: { only_integer: true }
  validate :age_range_in_order

  scope :for_kind, ->(kind) { where(kind: kind) }
  scope :ordered, -> { order(:position, :id) }

  def adult?
    min_age.to_i >= ADULT_AGE
  end

  # "Age 6–17", "Age 18+", "Age 0–5"; nil when the ticket has no age limits.
  def age_label
    if min_age && max_age then "Age #{min_age}–#{max_age}"
    elsif min_age then "Age #{min_age}+"
    elsif max_age then "Up to age #{max_age}"
    end
  end

  private
    def age_range_in_order
      if min_age && max_age && min_age > max_age
        errors.add(:max_age, "must be greater than or equal to min age")
      end
    end
end
