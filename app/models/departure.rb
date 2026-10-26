class Departure < ApplicationRecord
  # Bookings close this long before the start time.
  BOOKING_CUTOFF = 1.day

  belongs_to :tour
  has_many :bookings, dependent: :restrict_with_error

  enum :kind, { group: "group", private: "private" }, prefix: true, validate: true
  enum :status, { open: "open", closed: "closed" }, prefix: true, validate: true

  validates :starts_at, presence: true, uniqueness: { scope: [ :tour_id, :kind ] }
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }
  # Can exceed capacity when the manager restores a cancelled booking onto a full departure.
  validates :seats_booked, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :for_kind, ->(kind) { where(kind: kind) }
  scope :chronological, -> { order(:starts_at) }
  scope :upcoming, -> { where("starts_at > ?", Time.current) }
  scope :bookable, -> { status_open.where("starts_at > ?", booking_cutoff) }
  scope :with_seats, ->(seats) { where("capacity - seats_booked >= ?", seats) }
  scope :available, -> { bookable.with_seats(1) }
  # Rome midnight to Rome midnight, whatever the DST offset that day.
  scope :on_date, ->(date) { where(starts_at: date.in_time_zone.all_day) }

  def self.booking_cutoff
    BOOKING_CUTOFF.from_now
  end

  def seats_left
    [ capacity - seats_booked, 0 ].max
  end

  def overbooked_by
    [ seats_booked - capacity, 0 ].max
  end

  # Called by Booking whenever its seats change. Locked so a booking made on the site at the same moment
  # isn't lost; never below zero, as the manager may have lowered the count by hand.
  def adjust_seats!(delta)
    return if delta.zero?
    lock!
    update_column :seats_booked, [ seats_booked + delta, 0 ].max
  end

  def too_late_to_book?
    starts_at <= self.class.booking_cutoff
  end

  def bookable?
    status_open? && !too_late_to_book? && seats_left.positive?
  end
end
