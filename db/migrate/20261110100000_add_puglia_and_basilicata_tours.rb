# Adds the seven Puglia and Basilicata tours (codes 1001–1007) to databases that already hold tours, without
# re-running the seeds, so tours edited in production are left alone. The content is frozen here rather than read
# from db/seeds/tours.yml, so later edits to that file can't change what this migration does. Each tour gets the
# same records the seeds create: highlights, inclusions, facts, a private ticket type, photos, and departures
# for the next 8 weeks. Every price is 0: set them in the admin.
class AddPugliaAndBasilicataTours < ActiveRecord::Migration[8.1]
  CANCELLATION = "Cancellations made less than 7 days before the tour are non-refundable.\nPre-booked admission tickets are non-refundable, regardless of the cancellation date."

  TOURS = YAML.safe_load(<<~'YAML')
    - slug: bari-taste-of-authentic-southern-italy
      code: 1001
      title: "Bari: A Taste of Authentic Southern Italy"
      tagline: Bari Vecchia, Saint Nicholas, and the Pasta Ladies
      subtitle: Medieval streets, magnificent Romanesque churches, traditional pasta-making alleys and a picturesque Adriatic waterfront.
      region: Puglia and Basilicata
      hours: 3
      transport: walking
      meeting_point: Piazza del Ferrarese, by the entrance to Bari Vecchia
      languages: [en, es, fr, it, de]
      tags: [food_and_cooking]
      photos: [bari-italy.webp, polignano-a-mare.webp]
      max_guests: 8
      times: ["09:30", "16:00"]
      what_we_think: |
        Bari is where most people land in Puglia, and most hurry straight on. That’s a mistake: its old town is a maze of whitewashed lanes where women still roll orecchiette on their doorsteps, and it holds one of the great pilgrimage churches of southern Italy. Three hours on foot is enough to fall for it.
      what_customers_think: "We thought Bari was just the airport. The old town turned out to be one of our favourite places in Italy."
      customer_name: "Emma & Tom"
      customer_origin: "Bristol, UK"
      finer_details: |
        Meet your guide at Piazza del Ferrarese and step into Bari Vecchia, the old town on its peninsula between two harbours. Visit the Basilica of San Nicola, built in the eleventh century to hold the relics of Saint Nicholas, and the Romanesque Cathedral of San Sabino nearby.

        Wander along Strada Arco Basso, where local women make orecchiette by hand at tables in the street, and past the Norman-Swabian Castle. The tour ends on the Lungomare, the long seafront promenade, with time for a coffee or a slice of focaccia barese.
      highlights:
        Basilica of San Nicola: The Romanesque shrine of Saint Nicholas, a pilgrimage site for East and West.
        The pasta alley: Watch orecchiette made by hand in the lanes of Bari Vecchia.
        Bari Cathedral: A twelfth-century Romanesque church with a crypt beneath.
        The Lungomare: A stroll along Bari’s grand Adriatic waterfront.
      included:
        - Licensed private guide
      excluded:
        - Food and drinks
        - Gratuities
      facts:
        Meeting point: Piazza del Ferrarese, by the entrance to the old town, 10 minutes before the start.
        Dress code: Shoulders and knees must be covered in the churches.
        Walking: About 3 km on flat, paved streets.

    - slug: matera-stones-stories-and-sassi
      code: 1002
      title: "Matera: Stones, Stories & Sassi"
      tagline: The City Carved from Rock
      subtitle: Rock-hewn churches, traditional cave homes, and panoramic viewpoints over the Sassi.
      region: Puglia and Basilicata
      hours: 3
      transport: walking
      meeting_point: Piazza Vittorio Veneto, by the Belvedere Luigi Guerricchio
      languages: [en, es, fr, it, de]
      tags: []
      photos: [matera-sassi.webp, matera-panorama.webp]
      max_guests: 8
      times: ["09:30", "15:30"]
      what_we_think: |
        Matera is one of the oldest continuously inhabited cities in the world, carved into the side of a ravine. Seventy years ago its cave districts were called the shame of Italy; today they’re a UNESCO site. A local guide brings the stones to life, from the frescoed rock churches to the homes families lived in until the 1950s.
      what_customers_think: "Nothing prepared us for Matera. Our guide grew up here and told us stories we’d never have found in a book."
      customer_name: "Isabelle"
      customer_origin: "Lyon, France"
      finer_details: |
        Meet your guide in Piazza Vittorio Veneto and start at the viewpoint over the Sasso Barisano. Walk down into the Sassi, the two cave districts that tumble towards the ravine, and step inside a rock-hewn church with Byzantine frescoes painted on the bare stone.

        Visit a traditional cave house, furnished as it was when families shared it with their animals, and learn how the city was emptied in the 1950s and brought back to life. The tour ends at a panoramic point across from the Murgia plateau, where the caves of the first inhabitants still look back at the town.
      highlights:
        The Sassi: Two cave districts carved into the side of a ravine.
        Rock-hewn churches: Byzantine frescoes painted straight onto the stone.
        A cave house: How families lived in the Sassi until the 1950s.
        Panoramic viewpoints: The best views over the town and the Murgia plateau.
      included:
        - Licensed private guide
        - Entry to a rock-hewn church and a cave house
      excluded:
        - Food and drinks
        - Gratuities
      facts:
        Meeting point: Piazza Vittorio Veneto, by the Belvedere Luigi Guerricchio, 10 minutes before the start.
        Walking: The Sassi are steep, with many stone steps. Wear comfortable shoes with a good grip.
        Summer: In July and August, we recommend the morning or late-afternoon tour to avoid the heat.

    - slug: lecce-baroque-walk-and-pasticciotto-tasting
      code: 1003
      title: "Lecce: Baroque Walk & Pasticciotto Tasting"
      tagline: The Florence of the South
      subtitle: Ornate churches, palaces, and a lively historic centre, with a stop for pasticciotto.
      region: Puglia and Basilicata
      hours: 3
      transport: walking
      meeting_point: Piazza Sant’Oronzo, by the Roman amphitheatre
      languages: [en, es, fr, it, de]
      tags: [food_and_cooking]
      photos: [lecce-italy.webp]
      max_guests: 8
      times: ["09:30", "16:30"]
      what_we_think: |
        Lecce’s honey-coloured stone is soft enough to carve like wood, and in the seventeenth century its builders went wild with it. The result is a whole city of extravagant Baroque façades. This walk covers the best of them, with a break for a warm pasticciotto, the custard pastry Lecce is famous for.
      what_customers_think: "The churches were stunning, but the pasticciotto stop might have been our favourite part."
      customer_name: "Daniel & Rosa"
      customer_origin: "Toronto, Canada"
      finer_details: |
        Meet your guide in Piazza Sant’Oronzo, where a Roman amphitheatre lies half-uncovered beneath the square. Walk to the Basilica of Santa Croce, whose façade is crowded with cherubs, monsters, and flowers carved in the local pietra leccese, and on to the Piazza del Duomo, enclosed on all sides by the cathedral, bell tower, and bishop’s palace.

        Along the way, stop at a historic pastry shop for a pasticciotto still warm from the oven, and see a workshop where artisans shape figures in papier-mâché, another Lecce tradition. The tour ends by the Porta Napoli, the triumphal gate of the old town.
      highlights:
        Basilica of Santa Croce: The masterpiece of Lecce’s Baroque, carved in golden stone.
        Piazza del Duomo: A square enclosed by cathedral, bell tower, and palaces.
        The Roman amphitheatre: Second-century ruins in the heart of the city.
        Pasticciotto tasting: Lecce’s custard-filled pastry, fresh from a historic bakery.
      included:
        - Licensed private guide
        - Pasticciotto and coffee
      excluded:
        - Church entries
        - Gratuities
      facts:
        Meeting point: Piazza Sant’Oronzo, by the Roman amphitheatre, 10 minutes before the start.
        Dress code: Shoulders and knees must be covered in the churches.
        Walking: About 2.5 km on flat, paved streets.

    - slug: matera-and-alberobello-from-bari
      code: 1004
      title: From Bari to Matera & Alberobello
      tagline: Cave Dwellings and Trulli in One Day
      subtitle: Matera’s extraordinary ancient cave dwellings and Alberobello’s enchanting trulli houses.
      region: Puglia and Basilicata
      hours: 9
      transport: car
      badge: day_trip
      meeting_point: Pickup from your hotel in Bari
      languages: [en, es, fr, it, de]
      tags: [day_trip]
      photos: [matera-panorama.webp, alberobello-italy.webp, matera-sassi.webp]
      max_guests: 6
      times: ["08:30"]
      what_we_think: |
        Matera and Alberobello are the two places everyone wants to see in this corner of Italy, and they’re about an hour apart, with no easy train between them. With your own car and driver from Bari, you can see both in a day: the cave city in the morning, the conical trulli in the afternoon.
      what_customers_think: "Two of the most unusual towns we’ve ever seen, in one easy day. Our driver made it effortless."
      customer_name: "Julia & Ben"
      customer_origin: "Boston, USA"
      finer_details: |
        Your driver collects you from your hotel in Bari and heads inland across the Murgia to Matera. With a local guide, walk down into the Sassi, the cave districts carved into the ravine, and visit a rock-hewn church and a traditional cave house.

        After lunch, the car takes you to Alberobello, a town of more than a thousand trulli, the whitewashed stone houses with conical roofs. Wander the lanes of the Rione Monti, step inside a trullo, and see the Trullo Sovrano, the only one built on two floors, before the drive back to Bari.
      highlights:
        Matera’s Sassi: Cave homes and rock churches with a local guide.
        Alberobello: A UNESCO town of whitewashed trulli with conical stone roofs.
        Inside a trullo: See how these unusual houses are built and lived in.
        Your own driver: Door to door from your hotel in Bari, with no timetables.
      included:
        - Hotel pickup and drop-off in Bari
        - Private air-conditioned car and driver
        - Licensed guide in Matera
      excluded:
        - Entries in Matera and Alberobello
        - Lunch
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in Bari. Matera is about an hour’s drive.
        Your driver: Drivers are not licensed to guide inside the towns, but they know the area well.
        Walking: The Sassi are steep, with many stone steps. Wear comfortable shoes with a good grip.

    - slug: alberobello-and-valle-d-itria-from-bari
      code: 1005
      title: From Bari to Alberobello & the Valle d’Itria
      tagline: Trulli, Olive Groves, and a Winery
      subtitle: Whitewashed trulli, the Valle d’Itria with its olive groves, dry-stone walls, family-run masserias and a winery visit.
      region: Puglia and Basilicata
      hours: 8
      transport: car
      badge: day_trip
      meeting_point: Pickup from your hotel in Bari
      languages: [en, es, fr, it, de]
      tags: [day_trip, wine]
      photos: [alberobello-italy.webp, puglia-wine.webp]
      max_guests: 6
      times: ["09:00"]
      what_we_think: |
        The Valle d’Itria is the Puglia of postcards: trulli scattered among ancient olive trees, dry-stone walls, and white hill towns on every ridge. It’s countryside best seen slowly, with your own driver, a long lunch at a masseria, and a glass of local wine at the end of the day.
      what_customers_think: "The countryside was so beautiful we kept asking our driver to stop. The masseria lunch was unforgettable."
      customer_name: "Claudia"
      customer_origin: "Munich, Germany"
      finer_details: |
        Your driver collects you from your hotel in Bari and heads south to Alberobello. Walk through the Rione Monti, its hillside covered in whitewashed trulli, and step inside one to see how they’re built without mortar.

        Continue into the Valle d’Itria, past olive groves and dry-stone walls, to the white town of Locorotondo, built in a circle on its hilltop. Have lunch at a family-run masseria, a fortified farmhouse, then finish the day at a local winery to taste its wines before the drive back to Bari.
      highlights:
        Alberobello: A UNESCO town of whitewashed trulli with conical stone roofs.
        The Valle d’Itria: Olive groves, dry-stone walls, and trulli scattered across the hills.
        A masseria lunch: Puglian cooking at a family-run fortified farmhouse.
        A winery visit: A tasting of local wines to end the day.
      included:
        - Hotel pickup and drop-off in Bari
        - Private air-conditioned car and driver
        - Winery visit and tasting
      excluded:
        - Lunch
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in Bari. Alberobello is about an hour’s drive.
        Your driver: Drivers are not licensed to guide inside the towns, but they know the area well.
        Tasting: Guests must be 18 or older to taste.

    - slug: polignano-a-mare-and-monopoli-from-bari
      code: 1006
      title: From Bari to Polignano a Mare & Monopoli
      tagline: Clifftop Towns on the Adriatic
      subtitle: Dramatic Adriatic views, old-town strolls, and a seaside lunch.
      region: Puglia and Basilicata
      hours: 6
      transport: car
      badge: day_trip
      meeting_point: Pickup from your hotel in Bari
      languages: [en, es, fr, it, de]
      tags: [day_trip]
      photos: [polignano-a-mare.webp, bari-italy.webp]
      max_guests: 6
      times: ["09:30"]
      what_we_think: |
        South of Bari, the coast breaks into limestone cliffs and little coves of turquoise water, with two of Puglia’s prettiest towns perched right on the edge. This is an easy, relaxed day: two old towns to wander, a long seafood lunch by the water, and back in Bari by late afternoon.
      what_customers_think: "Polignano took our breath away. Lunch by the sea in Monopoli was the perfect end to the day."
      customer_name: "Sarah & James"
      customer_origin: "Dublin, Ireland"
      finer_details: |
        Your driver collects you from your hotel in Bari and follows the coast south to Polignano a Mare. Walk through the old town to the terraces built on the edge of the cliffs, and look down on the Lama Monachile, the cove framed by a Bourbon bridge.

        Continue to Monopoli, a working fishing town with a harbour full of blue wooden boats. Stroll its old town and the sea walls of its castle, then have a seafood lunch by the water before the drive back to Bari.
      highlights:
        Polignano a Mare: A whitewashed old town on the edge of limestone cliffs.
        Lama Monachile: Puglia’s most famous cove, framed by a Bourbon bridge.
        Monopoli: A fishing harbour, an old town, and a seafront castle.
        A seaside lunch: Fresh seafood looking out over the Adriatic.
      included:
        - Hotel pickup and drop-off in Bari
        - Private air-conditioned car and driver
      excluded:
        - Lunch
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in Bari. Polignano is about 40 minutes’ drive.
        Your driver: Drivers are not licensed to guide inside the towns, but they know the area well.
        Swimming: In summer, bring a swimsuit; there’s time for a dip if you’d like one.

    - slug: puglia-for-serious-wine-lovers
      code: 1007
      title: Puglia from Bari for Serious Wine Lovers
      tagline: Primitivo, Negroamaro, and Nero di Troia
      subtitle: "Puglia’s finest wines from Bari: Primitivo, Negroamaro and Nero di Troia."
      region: Puglia and Basilicata
      hours: 8
      transport: car
      badge: wine
      meeting_point: Pickup from your hotel in Bari
      languages: [en, es, fr, it, de]
      tags: [wine, day_trip]
      photos: [puglia-wine.webp, alberobello-italy.webp]
      max_guests: 6
      days: [mon, tue, wed, thu, fri, sat]
      times: ["09:00"]
      what_we_think: |
        Puglia makes more wine than almost any region in Italy, and its best bottles are finally getting the attention they deserve. This day is for people who want to go beyond the tasting room: two serious producers, the grapes that define the region, and the people who grow them.
      what_customers_think: "We’d only known Primitivo from the supermarket. Tasting it at the source, with the winemaker, was a revelation."
      customer_name: "Greg & Helen"
      customer_origin: "Napa, USA"
      finer_details: |
        Your driver collects you from your hotel in Bari. The first winery grows Nero di Troia, the elegant red grape of northern Puglia. Walk the vineyards and cellars with the family, and taste their wines alongside local cheeses and olive oil.

        After lunch, head south towards Gioia del Colle and Manduria, home of Primitivo, the grape that became America’s Zinfandel. At the second winery, taste Primitivo and Negroamaro from different vineyards and vintages before the drive back to Bari.
      highlights:
        Two family wineries: Private visits and tastings with the people who make the wine.
        Primitivo: Puglia’s most famous red, the Italian twin of Zinfandel.
        Negroamaro and Nero di Troia: The native grapes of the heel of Italy.
        Your own driver: Taste freely; the driving is taken care of.
      included:
        - Hotel pickup and drop-off in Bari
        - Private air-conditioned car and driver
        - Two winery visits and tastings
      excluded:
        - Lunch
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in Bari.
        Tasting: Guests must be 18 or older to taste.
        Sundays: Most wineries close on Sundays, so the tour runs Monday to Saturday.
  YAML

  def up
    from = Date.current
    to = from + 8.weeks
    closed = (from.year..to.year).flat_map { |year| [ Date.new(year, 12, 25), Date.new(year, 1, 1) ] }

    TOURS.each do |data|
      if Tour.exists?(slug: data["slug"]) || Tour.exists?(code: data["code"])
        say "#{data["slug"]}: already exists, skipped"
        next
      end

      tour = Tour.create!(
        **data.slice("slug", "code", "title", "tagline", "subtitle", "region", "transport", "meeting_point", "languages",
                   "tags", "what_customers_think", "customer_name", "customer_origin", "badge").symbolize_keys,
        what_we_think: data["what_we_think"].strip,
        finer_details: data["finer_details"].strip,
        duration_minutes: (data["hours"] * 60).to_i,
        status: "published"
      )

      data["highlights"].each_with_index { |(title, body), position| tour.highlights.create!(title:, body:, position:) }
      inclusions = data["included"].map { |label| [ label, true ] } + data["excluded"].map { |label| [ label, false ] }
      inclusions.each_with_index { |(label, included), position| tour.inclusions.create!(label:, included:, position:) }
      data["facts"].merge("Cancellation" => CANCELLATION)
                   .each_with_index { |(label, body), position| tour.tour_facts.create!(label:, body:, position:) }

      # Every tour here is private, one price for the whole party. Prices are 0 until set in the admin.
      tour.ticket_types.create!(kind: "private", name: "Private group", max_guests: data["max_guests"], price_cents: 0, position: 0)

      data["photos"].each do |file|
        tour.photos.attach(io: Rails.root.join("app/assets/images/tours", file).open, filename: file, content_type: "image/webp")
      end

      days = data.fetch("days", Departures::Generator::DAYS).map(&:to_sym)
      created = Departures::Generator.call(tour:, kind: "private", times: data["times"], days:, capacity: 1,
                                           from:, to:, skip_dates: closed)
      say "#{tour.title}: added with #{created} departures"
    end
  end

  def down
    Tour.where(slug: TOURS.map { |data| data["slug"] }).find_each do |tour|
      raise ActiveRecord::IrreversibleMigration, "#{tour.title} has bookings" if tour.bookings.exists?

      tour.departures.delete_all(:delete_all)
      tour.destroy!
    end
  end
end
