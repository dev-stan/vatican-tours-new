# Adds the eight Milan and Lake Como tours to databases that already hold tours, without re-running the seeds,
# so tours edited in production are left alone. The content is frozen here rather than read from
# db/seeds/tours.yml, so later edits to that file can't change what this migration does. Each tour gets the
# same records the seeds create: highlights, inclusions, facts, a private ticket type, photos, and departures
# for the next 8 weeks. The tours have no code yet, and every price is 0: set both in the admin.
class AddMilanAndLakeComoTours < ActiveRecord::Migration[8.1]
  CANCELLATION = "Cancellations made less than 7 days before the tour are non-refundable.\nPre-booked admission tickets are non-refundable, regardless of the cancellation date."

  TOURS = YAML.safe_load(<<~'YAML')
    - slug: essential-milan
      title: Essential Milan
      tagline: The Duomo, La Scala, and the Galleria
      subtitle: From its artistic heritage to its vibrant local life.
      region: Milan and Lake Como
      hours: 3
      transport: walking
      meeting_point: Piazza del Duomo, under the equestrian statue of Victor Emmanuel II
      languages: [en, es, fr, it, de]
      tags: []
      photos: [essential-milan.webp, milan-in-depth.webp]
      max_guests: 8
      times: ["09:30", "14:30"]
      what_we_think: |
        Milan keeps its best side hidden behind elegant façades and busy shopping streets. Three hours on foot with a local guide is the quickest way in: the great Gothic cathedral, the opera house, the city’s grandest arcade, and the corners where the Milanese actually live.
      what_customers_think: "We only had a day in Milan before heading to the lakes. Our guide showed us far more than we could have found ourselves."
      customer_name: "Karen & Steve"
      customer_origin: "Denver, USA"
      finer_details: |
        Meet your guide in Piazza del Duomo, in front of the cathedral that took nearly six centuries to finish. Step inside to see its stained glass and forest of marble columns, then walk through the Galleria Vittorio Emanuele II, the glass-roofed arcade the Milanese call their drawing room.

        Cross to Piazza della Scala and the world’s most famous opera house, then wander through the medieval Piazza dei Mercanti and on to the Brera district, with its cafés, galleries, and quiet courtyards. The tour ends at the Castello Sforzesco, the fortress of the dukes who ruled Renaissance Milan.
      highlights:
        Milan Cathedral: Six centuries of marble, spires, and stained glass.
        Galleria Vittorio Emanuele II: The glass-domed arcade at the heart of the city.
        La Scala: The opera house where Verdi and Puccini premiered their works.
        Brera and the Castello: Milan’s artists’ quarter and the Sforza fortress.
      included:
        - Licensed private guide
        - Milan Cathedral entry
      excluded:
        - Duomo rooftop terraces
        - Food and drinks
        - Gratuities
      facts:
        Meeting point: Piazza del Duomo, under the equestrian statue in the middle of the square, 10 minutes before the start.
        Dress code: Shoulders and knees must be covered inside the cathedral.
        Walking: About 3 km on flat, paved streets.

    - slug: essential-milan-and-last-supper
      title: Essential Milan & Last Supper
      tagline: Leonardo’s Masterpiece and the Heart of Milan
      subtitle: Milan’s iconic Last Supper and the city’s rich cultural heritage.
      region: Milan and Lake Como
      hours: 3
      transport: walking
      meeting_point: Piazza di Santa Maria delle Grazie, in front of the church
      languages: [en, es, fr, it, de]
      tags: []
      photos: [last-supper-milan.webp, essential-milan.webp]
      max_guests: 8
      days: [tue, wed, thu, fri, sat, sun]
      times: ["09:00", "14:00"]
      what_we_think: |
        Tickets to the Last Supper are among the hardest to find in Italy: only a few people are let in at a time, for fifteen minutes. This tour takes care of them and adds a walk to the Duomo, so you see Leonardo’s masterpiece and the best of the historic centre in one morning or afternoon.
      what_customers_think: "Every Last Supper ticket was sold out online. This tour got us in, and the walk afterwards was a lovely bonus."
      customer_name: "Hannah"
      customer_origin: "Melbourne, Australia"
      finer_details: |
        Meet your guide at the church of Santa Maria delle Grazie. Before your timed entry, hear how Leonardo painted the Last Supper on the refectory wall in the 1490s, why it began to flake within his lifetime, and how it survived a bomb that destroyed the room around it in 1943. Then step inside for fifteen minutes in front of the painting.

        From the church, walk along Corso Magenta, past the Castello Sforzesco, and into the historic centre. The tour ends in Piazza del Duomo, after a stroll through the Galleria Vittorio Emanuele II and a stop outside La Scala.
      highlights:
        The Last Supper: Fifteen minutes with Leonardo’s masterpiece, tickets reserved.
        Santa Maria delle Grazie: The Renaissance church built around the refectory.
        Castello Sforzesco: The fortress of the dukes who brought Leonardo to Milan.
        The Duomo and the Galleria: The great Gothic cathedral and Milan’s grandest arcade.
      included:
        - Licensed private guide
        - Reserved Last Supper tickets
      excluded:
        - Milan Cathedral entry
        - Food and drinks
        - Gratuities
      facts:
        Meeting point: Piazza di Santa Maria delle Grazie, in front of the church, 20 minutes before the start.
        The Last Supper: Visits are strictly timed at 15 minutes, and latecomers can’t be let in. Bags larger than a handbag must be left in the cloakroom.
        Closed Mondays: The Last Supper is closed on Mondays, so the tour runs Tuesday to Sunday.

    - slug: milan-in-depth-and-last-supper
      title: Milan in Depth & Last Supper
      tagline: Old Masters and the New Skyline
      subtitle: Experience Milan’s distinctive blend of history, art, and contemporary life.
      region: Milan and Lake Como
      hours: 5
      transport: car
      meeting_point: Pickup from your hotel in central Milan
      languages: [en, es, fr, it, de]
      tags: []
      photos: [milan-in-depth.webp, last-supper-milan.webp, essential-milan.webp]
      max_guests: 6
      days: [tue, wed, thu, fri, sat, sun]
      times: ["09:00"]
      what_we_think: |
        Most visitors see the Duomo and the Last Supper and leave thinking Milan is a museum. It isn’t: it’s Italy’s most modern city, and this tour shows both sides. With a car and driver, you can go from Leonardo to the vertical forests of Porta Nuova without wasting time between them.
      what_customers_think: "We wanted the classics, but also to understand modern Milan. Five hours with a car meant we didn’t miss anything."
      customer_name: "Richard & Priya"
      customer_origin: "London, UK"
      finer_details: |
        Your driver and guide collect you from your hotel. Start at Santa Maria delle Grazie and fifteen minutes in front of Leonardo’s Last Supper, then visit the Basilica of Sant’Ambrogio, founded by Milan’s patron saint in the fourth century, and the Castello Sforzesco.

        In the centre, walk from the Duomo through the Galleria Vittorio Emanuele II to La Scala. Then the car takes you to the other Milan: the Navigli canals Leonardo helped design, and the towers of Porta Nuova, where the Bosco Verticale grows a forest up the side of two apartment blocks. The tour ends back at your hotel.
      highlights:
        The Last Supper: Fifteen minutes with Leonardo’s masterpiece, tickets reserved.
        Sant’Ambrogio: Milan’s oldest church, founded in the fourth century.
        The Duomo and La Scala: The cathedral, the Galleria, and the opera house.
        Modern Milan: The Navigli canals and the Bosco Verticale at Porta Nuova.
      included:
        - Hotel pickup and drop-off in Milan
        - Private air-conditioned car and driver
        - Licensed private guide
        - Reserved Last Supper tickets
      excluded:
        - Milan Cathedral entry
        - Food and drinks
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in central Milan.
        The Last Supper: Visits are strictly timed at 15 minutes. Bags larger than a handbag must be left in the cloakroom.
        Dress code: Shoulders and knees must be covered in the churches.
        Closed Mondays: The Last Supper is closed on Mondays, so the tour runs Tuesday to Sunday.

    - slug: day-on-lake-como-from-milan
      title: A Day on Lake Como from Milan
      tagline: Como, Villa Carlotta, and Bellagio
      subtitle: A day of lakeside scenery, elegant villages, and mountain views.
      region: Milan and Lake Como
      hours: 8
      transport: car
      badge: day_trip
      meeting_point: Pickup from your hotel in central Milan
      languages: [en, es, fr, it, de]
      tags: [day_trip]
      photos: [day-on-lake-como-from-milan.webp, lake-como-from-bellagio.webp]
      max_guests: 6
      times: ["08:30"]
      what_we_think: |
        Lake Como is only an hour from Milan, but reaching the best of it by train and ferry takes most of a day. With your own car and driver, you can see the town of Como, the gardens of the western shore, and Bellagio in one easy loop, and be back in Milan for dinner.
      what_customers_think: "We didn’t want to spend the day working out ferry timetables. Our driver took care of everything and we just enjoyed the lake."
      customer_name: "Marta & Jakub"
      customer_origin: "Warsaw, Poland"
      finer_details: |
        Your driver collects you from your hotel in Milan and heads north to Como. Walk along the lakefront and through the old town to its marble cathedral, then follow the road up the western shore, past the villas of Cernobbio, to Tremezzo and the terraced gardens of Villa Carlotta.

        From Cadenabbia, the car ferry crosses to Bellagio, the pearl of the lake, at the point where its three branches meet. Have lunch, wander its stepped lanes and lakeside promenade, then the car takes you back to Milan in the late afternoon.
      highlights:
        Como: The lakefront promenade and a cathedral in white marble.
        Villa Carlotta: Terraced gardens and a sculpture collection above the water.
        Bellagio: Cobbled lanes and views up all three branches of the lake.
        Your own driver: Door to door from your hotel in Milan, with no timetables.
      included:
        - Hotel pickup and drop-off in Milan
        - Private air-conditioned car and driver
        - Car ferry to Bellagio
      excluded:
        - Villa Carlotta entry
        - Lunch
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in central Milan. Como is about an hour’s drive.
        Your driver: Drivers are not licensed to guide inside the villas or towns, but they know the lake well.
        Seasons: Villa Carlotta is open from late March to early November. Out of season, we’ll suggest another stop.

    - slug: lake-como-water-taxi-cruise-from-milan
      title: Lake Como with Water Taxi Cruise from Milan
      tagline: The Lake from the Water
      subtitle: Enjoy a scenic Lake Como water taxi cruise, surrounded by charming villages and mountain views.
      region: Milan and Lake Como
      hours: 8
      transport: car
      badge: cruises
      meeting_point: Pickup from your hotel in central Milan
      languages: [en, es, fr, it, de]
      tags: [cruises, day_trip]
      photos: [watertaxi-como-milan.webp, watertaxi-from-bellagio-como.webp, lake-como-from-bellagio.webp]
      max_guests: 6
      times: ["08:30"]
      what_we_think: |
        Lake Como’s grand villas were built to be seen from the water, and a wooden water taxi is the way to see them. This day pairs the comfort of a private car from Milan with a private cruise up the lake, ending with free time in Bellagio.
      what_customers_think: "Gliding past the villas in a wooden boat was the highlight of our trip to Italy. Worth every minute."
      customer_name: "Jennifer"
      customer_origin: "Vancouver, Canada"
      finer_details: |
        Your driver collects you from your hotel in Milan and heads north to Como. After a short walk along the lakefront, step aboard your private water taxi and cruise up the lake past Villa d’Este at Cernobbio, the villas of Laglio, and the island of Comacina, the lake’s only island.

        Round the point of Lavedo for a view of Villa del Balbianello, then cross to Bellagio, where the cruise ends. Have lunch and time to explore, then your driver meets you in Bellagio for the drive back to Milan.
      highlights:
        A private water taxi: A classic wooden boat, just for your party.
        Villa d’Este and Villa del Balbianello: Lake Como’s grandest villas, seen from the water.
        Isola Comacina: The lake’s only island, once a medieval stronghold.
        Bellagio: Lunch and free time in the pearl of the lake.
      included:
        - Hotel pickup and drop-off in Milan
        - Private air-conditioned car and driver
        - Private water taxi cruise from Como to Bellagio
      excluded:
        - Villa entries
        - Lunch
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in central Milan. Como is about an hour’s drive.
        The cruise: About an hour and a half on the water. Boats carry up to 6 guests.
        Weather: If the lake is too rough to sail, we’ll drive to Bellagio instead and refund the cruise.

    - slug: day-on-lake-como-from-bellagio
      title: A Day on Lake Como from Bellagio
      tagline: Villas, Gardens, and Lakeside Villages
      subtitle: A relaxing day exploring Lake Como’s beautiful shores from Bellagio.
      region: Milan and Lake Como
      hours: 8
      transport: car
      meeting_point: Pickup from your hotel in Bellagio
      languages: [en, es, fr, it, de]
      tags: []
      photos: [lake-como-from-bellagio.webp, day-on-lake-como-from-milan.webp]
      max_guests: 6
      times: ["09:30"]
      what_we_think: |
        If you’re staying in Bellagio, the rest of the lake is right in front of you, but getting around it on public ferries takes patience. This day takes the hard work out of it: your own driver, the car ferries, and the best villas and villages on both shores.
      what_customers_think: "We were staying in Bellagio for a week and wanted one easy day seeing the rest of the lake."
      customer_name: "Paul & Annette"
      customer_origin: "Sydney, Australia"
      finer_details: |
        Your driver collects you from your hotel in Bellagio and takes the car ferry across to the western shore. Visit the gardens of Villa Carlotta at Tremezzo, then continue to Lenno for the walk to Villa del Balbianello, the loveliest villa on the lake, on its own wooded headland.

        After lunch in Menaggio, cross on the car ferry to Varenna on the eastern shore. Wander its pastel lanes and the gardens of Villa Monastero before the short crossing back to Bellagio.
      highlights:
        Villa Carlotta: Terraced gardens and a sculpture collection at Tremezzo.
        Villa del Balbianello: A villa on its own headland, reached by a lakeside path.
        Menaggio: Lunch in the main town of the western shore.
        Varenna: Pastel houses, steep lanes, and the gardens of Villa Monastero.
      included:
        - Hotel pickup and drop-off in Bellagio
        - Private air-conditioned car and driver
        - Car ferries
      excluded:
        - Villa entries
        - Lunch
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in Bellagio.
        Seasons: The villas are open from late March to early November. Out of season, we’ll suggest other stops.
        Walking: The path to Villa del Balbianello is about 1 km each way, with some steep sections.

    - slug: lake-como-by-water-taxi-from-bellagio
      title: Lake Como by Water Taxi from Bellagio
      tagline: Three Hours on the Water
      subtitle: Lake Como’s lakeside scenery on a water taxi ride.
      region: Milan and Lake Como
      hours: 3
      transport: boat
      badge: cruises
      meeting_point: Bellagio harbour, at the water taxi pier
      languages: [en, es, fr, it, de]
      tags: [cruises]
      photos: [watertaxi-from-bellagio-como.webp, watertaxi-como-milan.webp]
      max_guests: 8
      times: ["10:00", "14:30"]
      what_we_think: |
        From Bellagio, the whole centre of the lake is within easy reach by boat. Three hours in a private water taxi is enough to see the great villas from the water, stop in Varenna, and come back without ever looking at a ferry timetable.
      what_customers_think: "We wanted to see the lake from the water without crowded ferries. Our captain knew every villa and its story."
      customer_name: "Lisa"
      customer_origin: "Hamburg, Germany"
      finer_details: |
        Meet your captain at Bellagio’s harbour and head out past the gardens of Villa Melzi, then across to the western shore and Tremezzo, where Villa Carlotta rises above the water. Continue round the headland of Lavedo for the view of Villa del Balbianello.

        On the way back, cross to Varenna for a stop to stroll its waterfront and pastel lanes, then return to Bellagio across the widest part of the lake.
      highlights:
        A private water taxi: A classic wooden boat, just for your party.
        Villa del Balbianello: Lake Como’s most beautiful villa, seen from the water.
        Villa Carlotta and Villa Melzi: Grand villas and gardens along the shore.
        Varenna: A stop in the prettiest village on the eastern shore.
      included:
        - Private water taxi and captain
      excluded:
        - Villa entries
        - Food and drinks
        - Gratuities
      facts:
        Meeting point: Bellagio harbour, at the water taxi pier, 10 minutes before the start.
        The boat: Boats carry up to 8 guests. Bring a light jacket; it can be cool on the water.
        Weather: If the lake is too rough to sail, we’ll offer another time or a full refund.

    - slug: barolo-wine-tour-from-milan
      title: Barolo Wine Tour from Milan
      tagline: The King of Wines in the Langhe Hills
      subtitle: A day among Barolo’s vineyards, hilltop villages, and celebrated wines.
      region: Milan and Lake Como
      hours: 8
      transport: car
      badge: wine
      meeting_point: Pickup from your hotel in central Milan
      languages: [en, es, fr, it, de]
      tags: [wine, day_trip]
      photos: [barolo-wine-tour.webp]
      max_guests: 6
      days: [mon, tue, wed, thu, fri, sat]
      times: ["08:00"]
      what_we_think: |
        Barolo is called the king of wines and the wine of kings, and it comes from a small patch of hills in Piedmont, two hours from Milan. This day is for anyone who loves Italian wine: two family wineries, the castle villages of the Langhe, and a lunch to match.
      what_customers_think: "We drink Barolo at home and always wanted to see where it comes from. The wineries were small and personal."
      customer_name: "Michael & Sue"
      customer_origin: "Chicago, USA"
      finer_details: |
        Your driver collects you from your hotel in Milan and heads south-west into the Langhe hills. At the first winery, walk through the vineyards and cellars with the family that makes the wine, and taste their Barolo alongside the younger Nebbiolo and Dolcetto.

        Stop at La Morra, whose terrace looks out over the whole Barolo area, then have lunch in a village trattoria. In the afternoon, visit the village of Barolo, with its castle, and a second winery for another tasting before the drive back to Milan.
      highlights:
        Two family wineries: Private visits and tastings with the people who make the wine.
        Barolo: The village that gave the wine its name, and its castle.
        La Morra: The best view over the vineyards of the Langhe.
        Your own driver: Taste freely; the driving is taken care of.
      included:
        - Hotel pickup and drop-off in Milan
        - Private air-conditioned car and driver
        - Two winery visits and tastings
      excluded:
        - Lunch
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in central Milan. The Langhe are about two hours’ drive.
        Tasting: Guests must be 18 or older to taste.
        Truffle season: From October to December, Alba’s white truffle fair is nearby. Ask us to add a stop.
        Sundays: Most wineries close on Sundays, so the tour runs Monday to Saturday.
  YAML

  def up
    from = Date.current
    to = from + 8.weeks
    closed = (from.year..to.year).flat_map { |year| [ Date.new(year, 12, 25), Date.new(year, 1, 1) ] }

    TOURS.each do |data|
      if Tour.exists?(slug: data["slug"])
        say "#{data["slug"]}: already exists, skipped"
        next
      end

      tour = Tour.create!(
        **data.slice("slug", "title", "tagline", "subtitle", "region", "transport", "meeting_point", "languages", "tags",
                   "what_customers_think", "customer_name", "customer_origin", "badge").symbolize_keys,
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
