class PagesController < ApplicationController
  LOCATIONS = [
    "All Locations", "Vatican City", "Rome", "Rome Day Trips", "Florence", "Tuscany", "Umbria",
    "Naples, Pompeii and Amalfi Coast", "Puglia and Basilicata", "Venice", "Milan and Lake Como", "Sicily"
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
    "Naples, Pompeii and Amalfi Coast" => "Naples"
  }.freeze

  HERO_SUBTITLES = {
    "All Locations" => "Small-group and private tours across Italy, planned by people who live here",
    "Vatican City" => "Skip-the-line access to the Museums, Sistine Chapel, and St. Peter’s",
    "Rome" => "Ancient ruins, Baroque piazzas, and the lanes between them",
    "Rome Day Trips" => "Easy escapes from Rome to hill towns, villas, and the coast",
    "Florence" => "Renaissance masterpieces, Medici palaces, and the Duomo up close",
    "Tuscany" => "Vineyards, cypress roads, and medieval hill towns",
    "Umbria" => "Assisi, Orvieto, and the quiet green heart of Italy",
    "Naples, Pompeii and Amalfi Coast" => "Pizza, Roman ruins, and cliffside villages above the bluest water in Italy",
    "Puglia and Basilicata" => "Trulli, cave towns, and olive groves running to the sea",
    "Venice" => "Canals, St. Mark’s, and the quiet islands of the lagoon",
    "Milan and Lake Como" => "The Last Supper, fashion streets, and lakeside villas",
    "Sicily" => "Greek temples, Baroque towns, and Mount Etna’s slopes"
  }.freeze

  # Subtitles under the "Italy, seen up close" heading above the tour browser.
  SECTION_SUBTITLES = {
    "All Locations" => "Ancient ruins, Baroque piazzas, and the lanes between them.",
    "Vatican City" => "Sacred art, Renaissance grandeur, and the treasures of Vatican City.",
    "Rome" => "Ancient ruins, Baroque piazzas, and the lanes between them.",
    "Rome Day Trips" => "Easy escapes from Rome to hill towns, villas, and the coast.",
    "Florence" => "Renaissance masterpieces, Medici palaces, and the David up close.",
    "Tuscany" => "Vineyards, cypress roads, and medieval hill towns.",
    "Umbria" => "Olive groves, hilltop towns, and the green heart of Italy.",
    "Naples, Pompeii and Amalfi Coast" => "Ancient streets, volcanic ash, and cliffside villages above the sea.",
    "Puglia and Basilicata" => "Whitewashed towns, stone-carved cities, and rugged landscapes.",
    "Venice" => "Canals, St. Mark’s, and the quiet islands of the lagoon.",
    "Milan and Lake Como" => "The Last Supper, fashion streets, and lakeside villas.",
    "Sicily" => "Ancient temples, volcanic peaks, and sunlit Mediterranean shores."
  }.freeze

  FEATURE_ICONS = %i[arrow clock house person].freeze

  # The four feature blocks under the section heading, per location (paired with FEATURE_ICONS by position).
  FEATURES = {
    "All Locations" => [
      { title: "Straight past the line", body: "Reserved entry at Italy’s busiest sights means more time inside and less in the queue." },
      { title: "Your pace, your route", body: "Self-guided, small-group, or private: choose how much guiding you want, city by city." },
      { title: "Beyond the big names", body: "Hill towns, vineyards, islands, and kitchens most visitors never find." },
      { title: "For every traveler", body: "Families, first-timers, and wheelchair users all have a tour built for them." }
    ],
    "Vatican City" => [
      { title: "Straight past the line", body: "Timed, reserved entry means minutes at the gate instead of hours in the Roman sun." },
      { title: "Your pace, your route", body: "Self-guided packages let you linger at Raphael or rush to the Sistine Chapel." },
      { title: "Beyond the Museums", body: "Add St. Peter’s Basilica, the Dome climb, or the quiet Vatican Gardens." },
      { title: "For every traveler", body: "Families, first-timers, and wheelchair users all have a tour built for them." }
    ],
    "Rome" => [
      { title: "Straight past the line", body: "Reserved entry to the Colosseum, Forum, and Borghese Gallery skips the longest waits." },
      { title: "Your pace, your route", body: "Wander from the Pantheon to Trevi on your own, or let a local guide lead the way." },
      { title: "Beyond the ruins", body: "Trastevere food walks, underground catacombs, and sunset over the rooftops." },
      { title: "For every traveler", body: "Families, first-timers, and wheelchair users all have a tour built for them." }
    ],
    "Rome Day Trips" => [
      { title: "Door to door", body: "Pickup in Rome and comfortable transport, so the day starts the moment you leave." },
      { title: "Back by dinner", body: "Full days out that still get you back to Rome for an evening in the city." },
      { title: "Beyond the city", body: "Tivoli’s villas, Orvieto’s cathedral, the Castelli wineries, and the coast." },
      { title: "For every traveler", body: "Families, first-timers, and wheelchair users all have a tour built for them." }
    ],
    "Florence" => [
      { title: "Straight past the line", body: "Reserved entry to the Uffizi, the Accademia, and the Duomo means no hours in the queue." },
      { title: "Your pace, your route", body: "Linger with Botticelli or head straight to the David; the timing is yours." },
      { title: "Beyond the Duomo", body: "Climb Brunelleschi’s dome, cross to the Oltrarno workshops, or watch sunset from Piazzale Michelangelo." },
      { title: "For every traveler", body: "Families, first-timers, and wheelchair users all have a tour built for them." }
    ],
    "Tuscany" => [
      { title: "Door to door", body: "Pickup from Florence or Siena, with a driver who knows every back road." },
      { title: "Your pace, your route", body: "Linger over lunch in Chianti or fit San Gimignano and Siena into one day." },
      { title: "Beyond the vineyards", body: "Medieval towers, olive oil mills, and Val d’Orcia’s cypress-lined views." },
      { title: "For every traveler", body: "Families, first-timers, and wheelchair users all have a tour built for them." }
    ],
    "Umbria" => [
      { title: "Door to door", body: "Easy transport between hilltop towns that are hard to reach by train." },
      { title: "Your pace, your route", body: "Slow mornings in Assisi or a full loop through Orvieto, Spello, and Todi." },
      { title: "Beyond the basilicas", body: "Truffle hunts, Sagrantino tastings, and quiet medieval lanes." },
      { title: "For every traveler", body: "Families, first-timers, and wheelchair users all have a tour built for them." }
    ],
    "Naples, Pompeii and Amalfi Coast" => [
      { title: "Straight past the line", body: "Reserved entry to Pompeii and Herculaneum gets you in before the crowds and the heat." },
      { title: "Your pace, your route", body: "Explore the ruins on your own or with an archaeologist who brings them to life." },
      { title: "Beyond Pompeii", body: "Naples’ pizza and underground city, Vesuvius’ crater, and boats along the Amalfi Coast." },
      { title: "For every traveler", body: "Families, first-timers, and wheelchair users all have a tour built for them." }
    ],
    "Puglia and Basilicata" => [
      { title: "Door to door", body: "Comfortable transport across a region where trains and buses rarely line up." },
      { title: "Your pace, your route", body: "Wander Alberobello’s trulli or spend a full day among Matera’s cave dwellings." },
      { title: "Beyond the trulli", body: "Masseria lunches, olive groves, and whitewashed towns above the Adriatic." },
      { title: "For every traveler", body: "Families, first-timers, and wheelchair users all have a tour built for them." }
    ],
    "Venice" => [
      { title: "Straight past the line", body: "Reserved entry to St. Mark’s Basilica and the Doge’s Palace skips the longest queues." },
      { title: "Your pace, your route", body: "Get lost in the calli on your own, or follow a local through the hidden corners." },
      { title: "Beyond St. Mark’s", body: "Murano’s glassblowers, Burano’s colored houses, and a boat down the Grand Canal." },
      { title: "For every traveler", body: "Families, first-timers, and wheelchair users all have a tour built for them." }
    ],
    "Milan and Lake Como" => [
      { title: "Straight past the line", body: "Reserved tickets to The Last Supper, which sells out weeks ahead." },
      { title: "Your pace, your route", body: "A morning at the Duomo rooftops, an afternoon on the lake, or both in one day." },
      { title: "Beyond the city", body: "Lakeside villas, boat rides to Bellagio, and Franciacorta wineries." },
      { title: "For every traveler", body: "Families, first-timers, and wheelchair users all have a tour built for them." }
    ],
    "Sicily" => [
      { title: "Door to door", body: "Easy transport between temples, towns, and the slopes of Etna." },
      { title: "Your pace, your route", body: "A slow day in Taormina or a full loop through Syracuse and Noto." },
      { title: "Beyond the temples", body: "Etna wineries, street food in Palermo, and Baroque towns in golden stone." },
      { title: "For every traveler", body: "Families, first-timers, and wheelchair users all have a tour built for them." }
    ]
  }.freeze

  # The floating guide's advice pill and its modal, per location: a short teaser title and a few local tips.
  GUIDE_ADVICE = {
    "All Locations" => {
      title: "Where to start in Italy",
      tips: [
        "Pick two or three bases rather than a new town every night; trains between Rome, Florence, and Venice take under four hours.",
        "Book the big museums (Vatican, Uffizi, Last Supper) before anything else. They sell out weeks ahead in high season.",
        "Many churches close from noon to 3 p.m. Plan museums for midday and churches for mornings and late afternoons."
      ]
    },
    "Vatican City" => {
      title: "Beat the Sistine crowds",
      tips: [
        "Take the first entry of the day and head straight for the Sistine Chapel, then work backwards through the galleries.",
        "Cover shoulders and knees, or you’ll be turned away at St. Peter’s, and the dress code is enforced in summer too.",
        "Wednesday mornings the Basilica is busy with the papal audience; the Museums are usually quieter then."
      ]
    },
    "Rome" => {
      title: "Rome before 9 a.m.",
      tips: [
        "See the Trevi Fountain and the Pantheon before 9 a.m., and you’ll have them almost to yourself.",
        "Fill your bottle at the nasoni, the free drinking fountains on nearly every corner.",
        "Skip restaurants with photo menus near the big sights; walk two streets away and prices drop by a third."
      ]
    },
    "Rome Day Trips" => {
      title: "Picking the right day trip",
      tips: [
        "Tivoli’s Villa d’Este is at its best in spring, when every fountain is running.",
        "Orvieto is an easy hour by train: take the funicular up and the underground city tour.",
        "Avoid day trips on Mondays, when many sites outside Rome are closed."
      ]
    },
    "Florence" => {
      title: "The David without the wait",
      tips: [
        "Book the Accademia for the last slot of the day; the crowds thin and the light on the David is softer.",
        "Dome climb tickets are timed and sell out; reserve them together with the Baptistery and the museum.",
        "Cross the river to the Oltrarno for lunch: artisan workshops, fewer crowds, better trattorias."
      ]
    },
    "Tuscany" => {
      title: "Chianti without a car",
      tips: [
        "Most wineries need a booking; drop-in tastings are rare outside Montalcino and Montepulciano.",
        "San Gimignano empties after 5 p.m. when the coaches leave. Stay for sunset.",
        "Avoid driving into old town centres: the ZTL camera fines arrive months later."
      ]
    },
    "Umbria" => {
      title: "Assisi after the tour buses",
      tips: [
        "Arrive in Assisi after 4 p.m. or stay overnight; mornings and evenings are almost silent.",
        "Truffle season runs October to December, the best time for a hunt and a long lunch.",
        "Orvieto works well as a stop between Rome and Florence on the train."
      ]
    },
    "Naples, Pompeii and Amalfi Coast" => {
      title: "Pompeii in the summer heat",
      tips: [
        "Enter Pompeii at opening time, bring water and a hat, and expect very little shade.",
        "Herculaneum is smaller, better preserved, and a good choice if you only have half a day.",
        "On the Amalfi Coast, the ferry is often faster than the road in summer traffic."
      ]
    },
    "Puglia and Basilicata" => {
      title: "Matera after dark",
      tips: [
        "Stay a night in Matera; the Sassi are at their most striking lit up after sunset.",
        "Visit Alberobello early. By 11 a.m. the main trulli streets are packed.",
        "A car or a driver is almost essential here; public transport between towns is thin."
      ]
    },
    "Venice" => {
      title: "Losing the crowds in Venice",
      tips: [
        "Walk Cannaregio and Castello in the evening when day-trippers have gone home.",
        "Check the day-tripper access fee dates before you go if you’re not staying overnight.",
        "A traghetto across the Grand Canal costs a couple of euros, a gondola moment for a fraction of the price."
      ]
    },
    "Milan and Lake Como" => {
      title: "Booking the Last Supper",
      tips: [
        "Last Supper tickets release in batches about two months ahead; set a reminder and book on the day.",
        "Climb to the Duomo rooftops late afternoon for the softest light over the spires.",
        "On Lake Como, base yourself in Varenna or Bellagio and get around by ferry."
      ]
    },
    "Sicily" => {
      title: "Etna, the easy way",
      tips: [
        "Take the cable car up Etna and a guided walk to the craters; bring layers, it’s cold at the top even in July.",
        "Visit the Valley of the Temples late in the day for golden light and cooler air.",
        "Try arancini, cannoli, and granita with brioche for breakfast, a Sicilian habit worth adopting."
      ]
    }
  }.freeze

  def home
    @locations = LOCATIONS
    @categories = CATEGORIES
    @hero_places = HERO_PLACES
    @hero_subtitles = HERO_SUBTITLES
    @section_subtitles = SECTION_SUBTITLES
    @feature_icons = FEATURE_ICONS
    @features = FEATURES
    @guide_advice = GUIDE_ADVICE
    @tours = Tour.published.with_attached_photos.includes(:ticket_types)
                 .sort_by { |tour| [ LOCATIONS.index(tour.location) || LOCATIONS.size, tour.id ] }
  end

  def about
  end

  def privacy
  end
end
