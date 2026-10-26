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

  VATICAN_TOURS = [
    { id: "vat-1", duration: "3 hours", title: "Vatican Museums Self-Guided Skip-the-Line Package", sub: "Walk straight past the queue into Raphael’s Rooms and the Sistine Chapel", price: "US$49", reviews: "612 Reviews", photo: "Vatican Museums gallery" },
    { id: "vat-2", duration: "4 hours", title: "All Vatican Self-Guided Skip-the-Line Package", sub: "Museums, Sistine Chapel, and St. Peter’s Basilica at your own pace", price: "US$69", reviews: "438 Reviews", photo: "St. Peter’s Basilica nave" },
    { id: "vat-3", duration: "5 hours", title: "All Vatican Self-Guided Package Including the Dome", sub: "Finish your visit high above Rome on Michelangelo’s dome", price: "US$89", reviews: "Newly Added", photo: "View from St. Peter’s dome" },
    { id: "vat-4", duration: "6 hours", title: "Vatican in Depth with Gardens and Dome", sub: "Quiet gardens, grand galleries, and the city’s best rooftop view", price: "US$119", reviews: "257 Reviews", photo: "Vatican Gardens" }
  ].map { |t| t.merge(location: "Vatican City", categories: [ "Self Guided" ], price_label: "Self-Guided") }

  ROME_TOURS = [
    { id: 328, duration: "3 hours", title: "Ancient Rome Walking Tour", sub: "Ancient Rome with priority Colosseum and Forum passes", photo: "Colosseum", image: "tours/colloseum.webp", page: :ancient_rome_tour, categories: [ "Private Tours", "Small Group" ], price_label: "Private or Group" },
    { id: 329, duration: "5 hours", title: "Ancient Rome in Depth with Underground Colosseum", sub: "In-depth archaeological sites with a cappuccino break", photo: "Colosseum underground", image: "tours/colloseum_underground.webp", categories: [ "Private Tours", "Small Group" ], price_label: "Private or Group" },
    { id: 500, duration: "3 hours", title: "Old Rome Walking Tour", sub: "Centro storico, where locals outnumber tourists", photo: "Piazza Navona", image: "tours/piazza_navona.webp", categories: [ "Private Tours", "Small Group" ], price_label: "Private or Group" },
    { id: 323, duration: "2 hours", title: "Old Rome by Golf Cart", sub: "Top sights without walking; good for limited mobility", photo: "Golf cart in a Roman lane", image: "tours/golf_cart.webp", badge: :car, categories: [ "Private Tours", "With Kids", "Wheelchair" ], price_label: "Private" },
    { id: 498, duration: "2 hours", title: "Night Walk", sub: "Evening stroll through Rome’s streets and squares", photo: "Trevi Fountain at night", image: "tours/trevi_night.webp", categories: [ "Private Tours", "Small Group" ], price_label: "Private or Group" },
    { id: 331, duration: "3 hours", title: "Appian Way and the Catacombs Tour", sub: "Catacombs visit and walk on the Appian Way", photo: "Appian Way", image: "tours/appian_way.webp", categories: [ "Private Tours", "With Kids" ], price_label: "Private" },
    { id: 332, duration: "3 hours", title: "Rome Baroque Walking Tour", sub: "Caravaggio, Bernini, Borromini and the Borghese Gallery", photo: "Borghese Gallery", image: "tours/borghese_gallery.webp", categories: [ "Private Tours" ], price_label: "Private" },
    { id: 333, duration: "3 hours", title: "Jewish Rome Walking Tour", sub: "The Jewish Ghetto and its history", photo: "Jewish Ghetto", image: "tours/jewish_ghetto.webp", categories: [ "Private Tours" ], price_label: "Private" },
    { id: 499, duration: "3 hours", title: "Rome Underground for Smart Kids", sub: "Rome’s ancient sights, made fun for kids", photo: "Roman ruins", image: "tours/roman_ruins.webp", categories: [ "Private Tours", "With Kids" ], price_label: "Private" },
    { id: 392, duration: "3 hours", title: "On the Path of Angels and Demons Tour", sub: "Rome’s hidden clues from Dan Brown’s novel", photo: "Bernini fountain", image: "tours/bernini_fountain.webp", categories: [ "Private Tours" ], price_label: "Private" },
    { id: 400, duration: "3 hours", title: "Rome through the Lens with a Photographer", sub: "Photo walk with a professional photographer", photo: "Camera over a Roman piazza", image: "tours/roman_piazza.webp", categories: [ "Private Tours" ], price_label: "Private" },
    { id: 389, duration: "6 hours", title: "Rome, All the Sights Walking Tour", sub: "Old and Ancient Rome at a slow pace with a lunch break", photo: "Pantheon", image: "tours/pantheon.webp", categories: [ "Private Tours", "Small Group" ], price_label: "Private or Group" }
  ].map { |t| t.merge(location: "Rome") }

  ROME_DAY_TRIPS = [
    { id: 301, duration: "6 hours", title: "Tivoli Gardens and Hadrian’s Villa", sub: "Tivoli’s grand gardens and Hadrian’s vast villa", photo: "Villa d’Este fountains", image: "tours/villa_deste.webp", categories: [ "Private Tours" ], price_label: "Private by Car" },
    { id: 302, duration: "6 hours", title: "Ostia Antica and Etruscan Cerveteri by Car", sub: "Ancient Ostia and Cerveteri’s Etruscan heritage", photo: "Ostia Antica ruins", image: "tours/ostia_antica.webp", categories: [ "Private Tours" ], price_label: "Private by Car" },
    { id: 303, duration: "8 hours", title: "Palaces and Gardens of Rome Countryside", sub: "Elegant palaces and gardens in the Roman countryside", photo: "Countryside palace garden", image: "tours/countryside_palace.webp", categories: [ "Private Tours" ], price_label: "Private by Car" },
    { id: 304, duration: "6 hours", title: "Roman Hills and Winery Visit", sub: "Roman hills and a local winery", photo: "Vineyard in the Roman hills", image: "tours/vineyard.webp", categories: [ "Private Tours", "Wine Tours" ], price_label: "Private by Car" },
    { id: 305, duration: "10 hours", title: "Pompeii and Oplontis, the Excavations", sub: "Pompeii’s ancient streets and Oplontis’ Roman villa", photo: "Pompeii street", categories: [], price_label: "By Train and Car" },
    { id: 306, duration: "10 hours", title: "Pompeii, Herculaneum, Oplontis", sub: "Three remarkably preserved sites beneath Vesuvius", photo: "Herculaneum ruins", image: "tours/herculaneum.webp", categories: [], price_label: "By Train and Car" },
    { id: 307, duration: "10 hours", title: "Pompeii, Herculaneum and Vesuvius", sub: "Ancient ruins beneath Vesuvius", photo: "Mount Vesuvius", categories: [], price_label: "By Train and Car" },
    { id: 308, duration: "10 hours", title: "Pompeii, Amalfi Coast and Positano", sub: "Pompeii’s ruins and Positano’s colorful coastal streets", photo: "Positano", image: "tours/positano.webp", categories: [], price_label: "By Train and Car" },
    { id: 309, duration: "12 hours", title: "Pompeii, Sorrento, Capri", sub: "Pompeii’s ruins, Sorrento’s coast, and Capri’s island charm", photo: "Capri coastline", image: "tours/capri_coastline.webp", categories: [], price_label: "By Train and Car" },
    { id: 310, duration: "8 hours", title: "Assisi and Umbria", sub: "Assisi’s historic landmarks and Umbria’s hill towns", photo: "Basilica of St. Francis, Assisi", categories: [ "Private Tours" ], price_label: "Private by Car" },
    { id: 311, duration: "8 hours", title: "Tuscany, Villages and Countryside", sub: "Tuscany’s medieval villages and rolling countryside", photo: "Tuscan hill town", categories: [ "Private Tours" ], price_label: "Private by Car" },
    { id: 312, duration: "12 hours", title: "Florence, Chianti, Siena, Renaissance Marvels", sub: "Florence’s Renaissance treasures, Chianti’s countryside, and Siena’s medieval beauty", photo: "Florence Duomo", image: "tours/florence_duomo.webp", categories: [ "Private Tours" ], price_label: "Private by Car" }
  ].map { |t| t.merge(location: "Rome Day Trips") }

  TOURS = (VATICAN_TOURS + ROME_TOURS + ROME_DAY_TRIPS).freeze

  CARD_TINTS = { "Vatican City" => "bg-vatican-soft", "Rome" => "bg-rome-soft", "Rome Day Trips" => "bg-rome-soft" }.freeze

  def home
    @locations = LOCATIONS
    @categories = CATEGORIES
    @hero_places = HERO_PLACES
    @hero_subtitles = HERO_SUBTITLES
    @section_subtitles = SECTION_SUBTITLES
    @features = FEATURES
    @tours = TOURS
    @card_tints = CARD_TINTS
  end

  # Group tours are priced per ticket (under 6 free); private tours are a flat price for the whole party.
  ANCIENT_ROME_BOOKING = {
    group: { adult: 65, child: 45, max_guests: 12 },
    private: { price: 390, max_guests: 8 },
    # Days the Colosseum is closed, as "MM-DD".
    closed: [ "12-25", "01-01" ]
  }.freeze

  ANCIENT_ROME_SLOTS = [
    { time: "9:00 AM" },
    { time: "10:30 AM", note: "Most popular" },
    { time: "1:00 PM" },
    { time: "2:30 PM", note: "Few left" },
    { time: "4:00 PM" }
  ].freeze

  def ancient_rome_tour
    @booking = ANCIENT_ROME_BOOKING
    @slots = ANCIENT_ROME_SLOTS
  end

  # Thank-you page after Book Now. The total is recomputed here from the chosen options
  # rather than taken from the browser.
  def ancient_rome_booked
    mode = params[:mode] == "private" ? :private : :group
    pricing = ANCIENT_ROME_BOOKING[mode]
    adults = params[:adults].to_i
    children = params[:children].to_i
    date = Date.iso8601(params[:date].to_s) rescue nil
    slot = ANCIENT_ROME_SLOTS.find { |s| s[:time] == params[:time] }

    valid = adults >= 1 && children >= 0 && adults + children <= pricing[:max_guests] &&
      date && date >= Date.current && !ANCIENT_ROME_BOOKING[:closed].include?(date.strftime("%m-%d")) && slot
    return redirect_to ancient_rome_tour_path unless valid

    total = mode == :group ? adults * pricing[:adult] + children * pricing[:child] : pricing[:price]
    @booking = { mode: mode, adults: adults, children: children, date: date, time: slot[:time], total: total }
    @more_tours = ROME_TOURS.select { |t| [ 329, 500, 498 ].include?(t[:id]) }
    @card_tints = CARD_TINTS
  end
end
