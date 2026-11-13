class Tour < ApplicationRecord
  LANGUAGES = %w[en es fr it de pt].freeze
  TAGS = %w[self_guided with_kids wheelchair transfers day_trip cruises food_and_cooking wine active].freeze

  # Each region's accent: the tour card tint on the home page, the quick-facts strip and accents on the tour page.
  REGION_COLORS = {
    "Vatican City" => "#dbd007", "Rome" => "#C0643A", "Rome Day Trips" => "#D4895C", "Florence" => "#6E8466",
    "Tuscany" => "#8C9150", "Umbria" => "#4F6B4A", "Naples, Pompeii and Amalfi Coast" => "#B38A2B",
    "Puglia and Basilicata" => "#9C6B1F", "Venice" => "#2E6BA8", "Milan and Lake Como" => "#7A6A5A", "Sicily" => "#2F7F7E"
  }.freeze
  DEFAULT_REGION_COLOR = "#93421F"

  has_many_attached :photos

  has_many :highlights, -> { order(:position) }, dependent: :destroy
  has_many :inclusions, -> { order(:position) }, dependent: :destroy
  has_many :tour_facts, -> { order(:position) }, dependent: :destroy
  has_many :ticket_types, -> { order(:position) }, dependent: :destroy
  has_many :departures, dependent: :restrict_with_error
  has_many :bookings, dependent: :restrict_with_error
  has_many :newsletter_articles, dependent: :nullify
  has_many :promoted_tours, dependent: :destroy

  enum :status, { draft: "draft", published: "published" }, validate: true
  # How the tour gets around; picks the icon on the tour card.
  enum :transport, { walking: "walking", boat: "boat", car: "car" }, prefix: true, validate: true
  # Optional pill on the tour card photo: one of the tour's own tags, featured. The tours_badge_valid
  # check constraint enforces both rules in the database too.
  enum :badge, { wine: "wine", day_trip: "day_trip", transfers: "transfers", wheelchair: "wheelchair",
                 with_kids: "with_kids", cruises: "cruises", active: "active" }, prefix: true, validate: { allow_nil: true }

  normalizes :languages, :tags, with: ->(values) { Array(values).map(&:to_s).compact_blank.uniq }

  validates :title, :region, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }
  validates :code, uniqueness: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }
  validate :languages_are_known, :tags_are_known, :badge_is_tagged

  # Tours carrying ALL of the given tags. Tags live in a json array (SQLite has no
  # array type); on Postgres this becomes `where("tags @> ARRAY[?]::varchar[]", tags)`.
  scope :tagged_with, ->(*tags) {
    tags.flatten.compact_blank.map(&:to_s).uniq.reduce(all) do |relation, tag|
      relation.where("EXISTS (SELECT 1 FROM json_each(tours.tags) WHERE json_each.value = ?)", tag)
    end
  }
  # Ascending by tour ID (code: Vatican 100+, next region 200+, …); tours without a code go last.
  scope :by_code, -> { order(Arel.sql("tours.code IS NULL"), :code, :id) }
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

  def region_color = REGION_COLORS.fetch(region, DEFAULT_REGION_COLOR)

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

    def badge_is_tagged
      return if badge.nil? || tags.include?(badge)
      errors.add(:badge, "must also be ticked in Tags (#{ToursHelper::TAG_CATEGORIES.fetch(badge, badge.humanize)})")
    end
end
