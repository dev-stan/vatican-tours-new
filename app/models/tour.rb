class Tour < ApplicationRecord
  LANGUAGES = %w[en es fr it de pt].freeze
  TAGS = %w[self_guided with_kids wheelchair transfers cruises food_and_cooking wine active].freeze

  has_many_attached :photos

  has_many :highlights, -> { order(:position) }, dependent: :destroy
  has_many :inclusions, -> { order(:position) }, dependent: :destroy
  has_many :tour_facts, -> { order(:position) }, dependent: :destroy
  has_many :ticket_types, -> { order(:position) }, dependent: :destroy
  has_many :departures, dependent: :restrict_with_error
  has_many :bookings, dependent: :restrict_with_error

  enum :status, { draft: "draft", published: "published" }, validate: true
  # How the tour gets around; picks the icon on the tour card.
  enum :transport, { walking: "walking", boat: "boat", car: "car" }, prefix: true, validate: true
  # Optional pill on the tour card photo; at most one per tour.
  enum :badge, { wheelchair: "wheelchair", cruise: "cruise", food: "food", wine: "wine", active: "active" }, prefix: true, validate: { allow_nil: true }

  normalizes :languages, :tags, with: ->(values) { Array(values).map(&:to_s).compact_blank.uniq }

  validates :title, :location, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }
  validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }
  validate :languages_are_known, :tags_are_known

  # Tours carrying ALL of the given tags. Tags live in a json array (SQLite has no
  # array type); on Postgres this becomes `where("tags @> ARRAY[?]::varchar[]", tags)`.
  scope :tagged_with, ->(*tags) {
    tags.flatten.compact_blank.map(&:to_s).uniq.reduce(all) do |relation, tag|
      relation.where("EXISTS (SELECT 1 FROM json_each(tours.tags) WHERE json_each.value = ?)", tag)
    end
  }
  # "Private Tours" / "Small Group": the tour sells tickets of that kind.
  scope :offering, ->(kind) { where(id: TicketType.where(kind: kind).select(:tour_id)) }
  # "Group size N": a departure that can still be booked has N seats free.
  scope :with_seats_for, ->(guests) { where(id: Departure.bookable.with_seats(guests).select(:tour_id)) }

  # Listing-page filters. Every condition is a subquery on tours.id, so no duplicates.
  # A class method, not a scope: Relation#filter is Enumerable's, so call it as Tour.filter(...).
  def self.filter(tags: [], kind: nil, group_size: nil)
    relation = published.tagged_with(*Array(tags))
    relation = relation.offering(kind) if kind.present?
    relation = relation.with_seats_for(group_size.to_i) if group_size.to_i.positive?
    relation
  end

  def to_param = slug

  # The lowest price to join: the cheapest adult group ticket or the private price, optionally of one kind only.
  # Nil until the tour has prices.
  def starting_price_cents(kind = nil)
    ticket_types.select { |ticket| (kind.nil? || ticket.kind == kind) && (ticket.kind_private? || ticket.adult?) }
                .map(&:price_cents).min
  end

  # Private tickets by party size, smallest first; a private party pays the first one it fits.
  # A flat-priced private tour has just one.
  def private_tickets
    ticket_types.select(&:kind_private?).sort_by { |ticket| ticket.max_guests || Float::INFINITY }
  end

  # The private ticket a party of this size pays; nil when the party is too large.
  def private_ticket_for(guests)
    private_tickets.find { |ticket| ticket.max_guests.nil? || ticket.max_guests >= guests }
  end

  def offered_kinds
    ticket_types.map(&:kind).uniq
  end

  private
    def languages_are_known
      unknown = languages - LANGUAGES
      errors.add(:languages, "contains unknown codes: #{unknown.join(", ")}") if unknown.any?
    end

    def tags_are_known
      unknown = tags - TAGS
      errors.add(:tags, "contains unknown tags: #{unknown.join(", ")}") if unknown.any?
    end
end
