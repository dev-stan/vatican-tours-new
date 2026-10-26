class PagesController < ApplicationController
  LOCATIONS = [
    "All Locations", "Vatican City", "Rome", "Rome Day Trips", "Rome Transfers", "Florence", "Tuscany",
    "Umbria", "Naples and Amalfi Coast", "Pompeii", "Puglia and Basilicata", "Venice", "Milan and Lake Como", "Sicily"
  ].freeze

  CATEGORIES = [
    "Self Guided", "Private Tours", "Small Group", "With Kids", "Wheelchair",
    "Transfers", "Cruises", "Food and Cooking", "Wine Tours", "Active"
  ].freeze

  # Short place names for the hero title ("Vatican Seen Up Close"); unlisted locations use their tab label.
  HERO_PLACES = {
    "All Locations" => "Italy",
    "Vatican City" => "Vatican",
    "Rome Day Trips" => "Rome",
    "Rome Transfers" => "Rome"
  }.freeze

  HERO_SUBTITLES = {
    "All Locations" => "Small-group and private tours across Italy, planned by people who live here",
    "Vatican City" => "Skip-the-line access to the Museums, Sistine Chapel, and St. Peter’s",
    "Rome" => "Ancient ruins, Baroque piazzas, and the lanes between them",
    "Rome Day Trips" => "Easy escapes from Rome to hill towns, villas, and the coast",
    "Rome Transfers" => "Private drivers between airports, ports, and your hotel",
    "Florence" => "Renaissance masterpieces, Medici palaces, and the Duomo up close",
    "Tuscany" => "Vineyards, cypress roads, and medieval hill towns",
    "Umbria" => "Assisi, Orvieto, and the quiet green heart of Italy",
    "Naples and Amalfi Coast" => "Pizza, cliffside villages, and the bluest water in Italy",
    "Pompeii" => "Walk the streets of a Roman city frozen in time",
    "Puglia and Basilicata" => "Trulli, cave towns, and olive groves running to the sea",
    "Venice" => "Canals, St. Mark’s, and the quiet islands of the lagoon",
    "Milan and Lake Como" => "The Last Supper, fashion streets, and lakeside villas",
    "Sicily" => "Greek temples, Baroque towns, and Mount Etna’s slopes"
  }.freeze

  # Subtitles under the "Italy, Seen Up Close" heading above the tour browser.
  SECTION_SUBTITLES = {
    "All Locations" => "Ancient ruins, Baroque piazzas, and the lanes between them.",
    "Vatican City" => "Sacred art, Renaissance grandeur, and the treasures of Vatican City.",
    "Rome" => "Ancient ruins, Baroque piazzas, and the lanes between them.",
    "Rome Day Trips" => "Easy escapes from Rome to hill towns, villas, and the coast.",
    "Rome Transfers" => "Private drivers between airports, ports, and your hotel.",
    "Florence" => "Renaissance masterpieces, Medici palaces, and the David up close.",
    "Tuscany" => "Vineyards, cypress roads, and medieval hill towns.",
    "Umbria" => "Olive groves, hilltop towns, and the green heart of Italy.",
    "Naples and Amalfi Coast" => "Pizza, cliffside villages, and the bluest water in Italy.",
    "Pompeii" => "Ancient streets, volcanic ash, and the shadow of Vesuvius.",
    "Puglia and Basilicata" => "Whitewashed towns, stone-carved cities, and rugged landscapes.",
    "Venice" => "Canals, St. Mark’s, and the quiet islands of the lagoon.",
    "Milan and Lake Como" => "The Last Supper, fashion streets, and lakeside villas.",
    "Sicily" => "Ancient temples, volcanic peaks, and sunlit Mediterranean shores."
  }.freeze

  FEATURES = [
    { icon: :arrow, title: "Straight past the line", body: "Timed, reserved entry means minutes at the gate instead of hours in the Roman sun." },
    { icon: :clock, title: "Your pace, your route", body: "Self-guided packages let you linger at Raphael or rush to the Sistine Chapel." },
    { icon: :house, title: "Beyond the Museums", body: "Add St. Peter’s Basilica, the Dome climb, or the quiet Vatican Gardens." },
    { icon: :person, title: "For every traveler", body: "Families, first-timers, and wheelchair users all have a tour built for them." }
  ].freeze

  def home
    @locations = LOCATIONS
    @categories = CATEGORIES
    @hero_places = HERO_PLACES
    @hero_subtitles = HERO_SUBTITLES
    @section_subtitles = SECTION_SUBTITLES
    @features = FEATURES
    @tours = Tour.published.with_attached_photos.includes(:ticket_types)
                 .sort_by { |tour| [ LOCATIONS.index(tour.location) || LOCATIONS.size, tour.id ] }
  end
end
