module ToursHelper
  # Shown on tour cards until a tour has ticket prices of its own.
  DEFAULT_PRICE_CENTS = 100_00

  # Tags as the home page category checkboxes label them. "Private Tours" and "Small Group" come from ticket types.
  TAG_CATEGORIES = {
    "self_guided" => "Self Guided", "with_kids" => "With Kids", "wheelchair" => "Wheelchair", "transfers" => "Transfers",
    "day_trip" => "Day Trips",     "cruises" => "Cruises", "food_and_cooking" => "Food and Cooking", "wine" => "Wine Tours", "active" => "Active"
  }.freeze

  # The pill text for each Tour badge. A badge is one of the tour's tags, so these are keyed by tag.
  BADGE_LABELS = {
    "wine" => "Wine Trip", "day_trip" => "Day Trip", "transfers" => "Transfer Tour", "wheelchair" => "Wheelchairs",
    "with_kids" => "Kids Friendly", "cruises" => "Cruise", "active" => "Active"
  }.freeze

  LANGUAGE_NAMES = { "en" => "English", "es" => "Spanish", "fr" => "French", "it" => "Italian", "de" => "German", "pt" => "Portuguese" }.freeze

  # Sets the --region CSS variable behind the `region` and `region-soft` colours (see application.css).
  def region_style(tour)
    "--region: #{tour.region_color}"
  end

  # 180 => "3 hours", 150 => "2 hours 30 min"
  def tour_duration(tour)
    hours, minutes = tour.duration_minutes.divmod(60)
    [ (pluralize(hours, "hour") if hours.positive?), ("#{minutes} min" if minutes.positive?) ].compact.join(" ")
  end

  # One card price for a party of `guests`; see tour_card_prices.
  def tour_card_price(tour, label, kind, guests)
    if kind == "group"
      { label: label, kind: kind, price: euros(tour.starting_price_cents("group") * guests) }
    elsif (ticket = tour.private_ticket_for(guests))
      { label: label, kind: kind, price: euros(ticket.price_cents) }
    else
      { label: label, kind: kind, price: "max #{tour.private_tickets.last.max_guests}" }
    end
  end

  # "Private or Group", "Private", "Small Group", "Self-Guided"; nil until the tour has ticket types.
  def tour_format(tour)
    kinds = tour.offered_kinds
    if tour.tags.include?("self_guided") then "Self-Guided"
    elsif kinds.include?("private") && kinds.include?("group") then "Private or Group"
    elsif kinds.include?("private") then "Private"
    elsif kinds.include?("group") then "Small Group"
    end
  end

  def tour_price_label(tour)
    tour_format(tour) || "From"
  end

  def tour_price(tour)
    euros(tour.starting_price_cents || DEFAULT_PRICE_CENTS)
  end

  # The prices on a tour card for a party of `guests` (the home page's "Your Group Size"): Private and Group when the
  # tour sells both, else one. Group is the adult ticket times the party; Private is the tier the party fits. A pair
  # with a kind is repriced in the browser by the tour-filter controller from tour_card_price_data, so the two must agree.
  #   [{ label: "Private", kind: "private", price: "€420" }, { label: "Group", kind: "group", price: "€260" }]
  # A party too large for every private tier shows "max 8" in place of the Private price.
  def tour_card_prices(tour, guests = 1)
    if tour_format(tour) == "Private or Group"
      both = { "Private" => "private", "Group" => "group" }.filter_map do |label, kind|
        tour.starting_price_cents(kind) && tour_card_price(tour, label, kind, guests)
      end
      return both if both.size == 2
    end
    kinds = tour.offered_kinds
    if kinds.one? && tour.starting_price_cents(kinds.first)
      [ tour_card_price(tour, tour_price_label(tour), kinds.first, guests) ]
    else
      [ { label: tour_price_label(tour), kind: nil, price: tour_price(tour) } ]
    end
  end

  # What the tour-filter controller needs to reprice a card: the adult group ticket and the private tiers,
  # smallest first, as [max_guests, price_cents] (max_guests nil on a flat-priced private tour).
  def tour_card_price_data(tour)
    { group: tour.starting_price_cents("group"),
      private: tour.private_tickets.map { |ticket| [ ticket.max_guests, ticket.price_cents ] } }
  end

  def tour_categories(tour)
    kinds = tour.offered_kinds
    categories = []
    categories << "Private Tours" if kinds.include?("private")
    categories << "Small Group" if kinds.include?("group")
    categories + tour.tags.filter_map { |tag| TAG_CATEGORIES[tag] }
  end

  # "English, Spanish, or French"
  def tour_languages(tour)
    tour.languages.map { |code| LANGUAGE_NAMES.fetch(code, code) }
        .to_sentence(two_words_connector: " or ", last_word_connector: ", or ")
  end

  # "The Finer Details" on the tour page, one paragraph per blank-line-separated block.
  def tour_finer_details(tour)
    tour.finer_details.to_s.split(/\n{2,}/).map(&:strip).compact_blank
  end
end
