module ToursHelper
  # Shown on tour cards until a tour has ticket prices of its own.
  DEFAULT_PRICE_CENTS = 100_00

  # Tags as the home page category checkboxes label them. "Private Tours" and "Small Group" come from ticket types.
  TAG_CATEGORIES = {
    "self_guided" => "Self Guided", "with_kids" => "With Kids", "wheelchair" => "Wheelchair", "transfers" => "Transfers",
    "cruises" => "Cruises", "food_and_cooking" => "Food and Cooking", "wine" => "Wine Tours", "active" => "Active"
  }.freeze

  LANGUAGE_NAMES = { "en" => "English", "es" => "Spanish", "fr" => "French", "it" => "Italian", "de" => "German", "pt" => "Portuguese" }.freeze

  CARD_TINTS = { "Vatican City" => "bg-vatican-soft", "Rome" => "bg-rome-soft", "Rome Day Trips" => "bg-rome-soft" }.freeze

  def tour_card_tint(tour)
    CARD_TINTS.fetch(tour.location, "bg-white")
  end

  # 180 => "3 hours", 150 => "2 hours 30 min"
  def tour_duration(tour)
    hours, minutes = tour.duration_minutes.divmod(60)
    [ (pluralize(hours, "hour") if hours.positive?), ("#{minutes} min" if minutes.positive?) ].compact.join(" ")
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

  # Label and price pairs for a tour card: [["Private", "€390"], ["Group", "€65"]] when it sells both, else one pair.
  def tour_card_prices(tour)
    if tour_format(tour) == "Private or Group"
      both = { "Private" => "private", "Group" => "group" }.filter_map do |label, kind|
        (cents = tour.starting_price_cents(kind)) && [ label, euros(cents) ]
      end
      return both if both.size == 2
    end
    [ [ tour_price_label(tour), tour_price(tour) ] ]
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

  # The description's first paragraph opens the tour page; the rest are the finer details.
  def tour_paragraphs(tour)
    tour.description.to_s.split(/\n{2,}/).map(&:strip).compact_blank
  end
end
