class Booking < ApplicationRecord
  REFERENCE_PREFIX = "VTI-"
  # No 0/O, 1/I/L, so references read back unambiguously over the phone.
  REFERENCE_ALPHABET = "23456789ABCDEFGHJKMNPQRSTUVWXYZ".chars.freeze

  belongs_to :tour
  belongs_to :departure

  # pending: requested on the site, waiting for the manager. confirmed: the manager has emailed the guest a
  # confirmation with payment details. Any status can change to any other from the admin.
  enum :status, { pending: "pending", confirmed: "confirmed", cancelled: "cancelled" }, validate: true

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :name, :phone, with: ->(value) { value.strip }

  before_validation :assign_reference, on: :create
  after_save :move_seats
  after_destroy { departure.adjust_seats!(-seats_held) }

  validates :reference, presence: true, uniqueness: true
  validates :name, :phone, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :guests, numericality: { only_integer: true, greater_than: 0 }
  validates :total_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :departure_belongs_to_tour

  def self.generate_reference
    loop do
      reference = REFERENCE_PREFIX + Array.new(4) { REFERENCE_ALPHABET.sample(random: SecureRandom) }.join
      break reference unless exists?(reference: reference)
    end
  end

  # Seats taken on the departure: a private booking takes the whole slot, a cancelled one takes none.
  def seats_held
    seats_on(departure, status, guests)
  end

  def ticket_lines
    tickets.map(&:with_indifferent_access)
  end

  private
    def assign_reference
      self.reference ||= self.class.generate_reference
    end

    def seats_on(departure, status, guests)
      if status == "cancelled" then 0
      elsif departure.kind_private? then 1
      else guests
      end
    end

    # Keeps seat counts in step with whatever changed, from the site or the admin: a new booking,
    # a status change, a different party size, or a move to another departure.
    def move_seats
      if previously_new_record?
        departure.adjust_seats!(seats_held)
      elsif saved_change_to_departure_id?
        previous = Departure.find(departure_id_before_last_save)
        previous.adjust_seats!(-seats_on(previous, status_before_last_save, guests_before_last_save))
        departure.adjust_seats!(seats_held)
      else
        departure.adjust_seats!(seats_held - seats_on(departure, status_before_last_save, guests_before_last_save))
      end
    end

    def departure_belongs_to_tour
      if departure && departure.tour_id != tour_id
        errors.add(:departure, "must belong to the booked tour")
      end
    end
end
