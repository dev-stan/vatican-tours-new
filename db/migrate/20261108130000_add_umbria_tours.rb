# Adds the eight Umbria tours (codes 701–708) to databases that already hold tours, without re-running the
# seeds, so tours edited in production are left alone. The content is frozen here rather than read from
# db/seeds/tours.yml, so later edits to that file can't change what this migration does. Each tour gets the
# same records the seeds create: highlights, inclusions, facts, private ticket types, photos, and departures
# for the next 8 weeks. Prices and copy are placeholders; edit them in the admin.
class AddUmbriaTours < ActiveRecord::Migration[8.1]
  CANCELLATION = "Cancellations made less than 7 days before the tour are non-refundable.\nPre-booked admission tickets are non-refundable, regardless of the cancellation date."

  TOURS = YAML.safe_load(<<~'YAML')
    - slug: assisi-and-cortona-day-in-umbria
      code: 701
      title: A Day in Umbria with Assisi and Cortona
      tagline: Saint Francis and a Tuscan Hill Town
      subtitle: The spiritual treasures of Assisi and the timeless charm of Cortona.
      region: Umbria
      hours: 8
      transport: car
      badge: day_trip
      meeting_point: Pickup from your hotel in central Rome
      languages: [en, es, fr, it]
      tags: [day_trip]
      photos: [assisi.webp, countryside_palace.webp]
      what_we_think: |
        Assisi and Cortona sit on facing hillsides across the border between Umbria and Tuscany, and a private car is the easiest way to see both in one day. The morning belongs to Saint Francis; the afternoon to Cortona’s steep lanes and wide views over the Val di Chiana.
      what_customers_think: "We loved Under the Tuscan Sun and always wanted to see Cortona. Assisi on the same day was a dream."
      customer_name: "Linda & Mark"
      customer_origin: "Portland, USA"
      finer_details: |
        Your driver collects you in Rome and heads north into Umbria. In Assisi, your guide leads you through the Basilica of St. Francis, its upper church covered in Giotto’s frescoes and its lower church holding the saint’s tomb, then along the pink stone streets to the Piazza del Comune.

        After lunch, the road crosses into Tuscany and climbs to Cortona, one of the oldest towns in Italy. Walk the main street to the Piazza della Repubblica and on to the town walls for the view across Lake Trasimeno before the drive back to Rome.
      highlights:
        Basilica of St. Francis: Giotto’s frescoes and the tomb of Italy’s patron saint.
        Assisi’s old town: Pink stone lanes, medieval squares, and the Temple of Minerva.
        Cortona: An Etruscan hill town with views across the Val di Chiana.
        Your own driver: A comfortable car, door to door from your hotel in Rome.
      included:
        - Hotel pickup and drop-off in Rome
        - Private air-conditioned car and driver
        - Licensed guide in Assisi
      excluded:
        - Lunch
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in central Rome. Assisi is about two and a half hours’ drive.
        Dress code: Shoulders and knees must be covered in the Basilica of St. Francis.
        Pace: Assisi and Cortona are both steep. Wear comfortable shoes.
      prices: { private: 1190, max_guests: 6 }
      times: ["07:30"]

    - slug: orvieto-and-civita-di-bagnoregio
      code: 702
      title: Orvieto and Bagnoregio
      tagline: A Cathedral on a Cliff and the Dying Town
      subtitle: The medieval charm of Orvieto and the magical hilltop village of Civita di Bagnoregio.
      region: Umbria
      hours: 8
      transport: car
      badge: day_trip
      meeting_point: Pickup from your hotel in central Rome
      languages: [en, es, fr, it]
      tags: [day_trip]
      photos: [countryside_palace.webp]
      what_we_think: |
        Orvieto stands on a block of volcanic rock above the Umbrian plain, crowned by one of the most beautiful cathedrals in Italy. Half an hour away, Civita di Bagnoregio clings to a crumbling pinnacle, reached only by a footbridge. Together they make one of the most striking days out from Rome.
      what_customers_think: "We saw a photo of Civita and knew we had to go. We want to see Orvieto too, without driving."
      customer_name: "Sofia"
      customer_origin: "Madrid, Spain"
      finer_details: |
        Your driver collects you in Rome and heads north to Civita di Bagnoregio. Walk across the long footbridge into the village, home to only a handful of residents, and through its single gate to the tiny main square.

        In the afternoon, Orvieto: its cathedral façade glitters with gold mosaics, and inside, Signorelli’s frescoes of the Last Judgement fill the San Brizio Chapel. Time for a walk through the old town before the drive back to Rome.
      highlights:
        Civita di Bagnoregio: A village on a crumbling hilltop, reached by footbridge.
        Orvieto Cathedral: A golden façade and Signorelli’s Last Judgement frescoes.
        Orvieto’s old town: Medieval lanes on top of a volcanic cliff.
        Your own driver: A comfortable car, door to door from your hotel in Rome.
      included:
        - Hotel pickup and drop-off in Rome
        - Private air-conditioned car and driver
        - Licensed guide in Orvieto
      excluded:
        - Civita di Bagnoregio entry fee
        - Orvieto Cathedral entry
        - Lunch
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in central Rome. Civita is about two hours’ drive.
        The footbridge: The walk up to Civita is steep. Allow 15 minutes each way.
        Dress code: Shoulders and knees must be covered in Orvieto Cathedral.
      prices: { private: 1190, max_guests: 6 }
      times: ["08:00"]

    - slug: assisi-by-train-from-rome
      code: 703
      title: Highlights of Assisi by Train from Rome
      tagline: Rome to Assisi on the Rails
      subtitle: Travel by train from Rome to discover the timeless beauty of Assisi, its medieval streets and the Basilica of St. Francis.
      region: Umbria
      hours: 3
      transport: walking
      badge: day_trip
      meeting_point: Assisi train station (Santa Maria degli Angeli), at the main exit
      languages: [en, es, fr, it]
      tags: [day_trip]
      photos: [assisi.webp]
      what_we_think: |
        Assisi is an easy train ride from Rome, and once you’re there you don’t need a car. Your guide meets you off the train and takes you up to the old town, through the Basilica of St. Francis and along the streets the saint walked eight centuries ago.
      what_customers_think: "We wanted to see Assisi without a long car ride. The train was easy and our guide was waiting for us."
      customer_name: "Thomas"
      customer_origin: "Munich, Germany"
      finer_details: |
        Take a morning train from Roma Termini to Assisi; we’ll suggest the best connection when you book. Your guide meets you at the station and rides with you up to the old town.

        Visit the Basilica of St. Francis, its upper church covered in Giotto’s frescoes and the saint’s tomb below, then walk to the Piazza del Comune and the Temple of Minerva. The tour ends in the old town, with time for lunch before the train back to Rome.
      highlights:
        Basilica of St. Francis: Giotto’s frescoes and the tomb of Italy’s patron saint.
        Piazza del Comune: Assisi’s main square and the Roman Temple of Minerva.
        No driving: An easy train from Rome and a guide waiting at the station.
        Medieval streets: Pink stone lanes and views across the Umbrian valley.
      included:
        - Licensed private guide in Assisi
        - Bus or taxi from Assisi station to the old town
      excluded:
        - Train tickets from Rome
        - Lunch
        - Gratuities
      facts:
        Meeting point: Assisi station (Santa Maria degli Angeli), at the main exit. Send us your train time when you book.
        The train: Direct trains from Roma Termini take about two hours.
        Dress code: Shoulders and knees must be covered in the Basilica of St. Francis.
      prices: { private: [360, 380, 400, 420, 440, 460] }
      times: ["10:30"]

    - slug: orvieto-and-winery-visit
      code: 704
      title: Orvieto and a Winery Visit
      tagline: Cathedral, Caves, and Orvieto Classico
      subtitle: The hilltop town of Orvieto with an exclusive winery visit and a tasting of fine local wines.
      region: Umbria
      hours: 6
      transport: car
      badge: wine
      meeting_point: Pickup from your hotel in central Rome
      languages: [en, es, fr, it]
      tags: [wine, day_trip]
      photos: [vineyard.webp, countryside_palace.webp]
      what_we_think: |
        Orvieto has been making white wine since the Etruscans dug cellars into the soft volcanic rock beneath the town. This tour pairs a morning in Orvieto with a private visit to a family winery in the hills below, finishing with a tasting of their Orvieto Classico.
      what_customers_think: "We like wine more than museums, but we wanted to see one beautiful hill town too. This was the perfect mix."
      customer_name: "Claire & Julien"
      customer_origin: "Lyon, France"
      finer_details: |
        Your driver collects you in Rome and heads north to Orvieto. With your guide, visit the cathedral and its golden façade, then walk the old town’s lanes to the edge of the cliff.

        After the tour, a short drive takes you down to a family winery among the vineyards. Walk through the cellars carved into the tufa, then sit down to taste their wines with local cheese and cured meats before the drive back to Rome.
      highlights:
        Orvieto Cathedral: A golden mosaic façade and Signorelli’s frescoes.
        A family winery: A private visit to cellars cut into the volcanic rock.
        Orvieto Classico: A guided tasting with local cheese and cured meats.
        Your own driver: Taste freely; the driving is taken care of.
      included:
        - Hotel pickup and drop-off in Rome
        - Private air-conditioned car and driver
        - Licensed guide in Orvieto
        - Winery visit and tasting
      excluded:
        - Orvieto Cathedral entry
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in central Rome. Orvieto is about an hour and a half’s drive.
        Tasting: Guests must be 18 or older to taste. Soft drinks are available for younger guests.
        Dress code: Shoulders and knees must be covered in Orvieto Cathedral.
      prices: { private: 1090, max_guests: 6 }
      times: ["09:00"]

    - slug: umbria-for-serious-wine-lovers
      code: 705
      title: Umbria for Serious Wine Lovers
      tagline: Orvieto Classico and Sagrantino
      subtitle: Orvieto Classico and the celebrated Sagrantino di Montefalco, with exclusive tastings at two wineries.
      region: Umbria
      hours: 8
      transport: car
      badge: wine
      meeting_point: Pickup from your hotel in central Rome
      languages: [en, es, fr, it]
      tags: [wine, day_trip]
      photos: [vineyard.webp, tuscan-winery.webp]
      what_we_think: |
        Umbria’s two great wines could hardly be more different: the crisp whites of Orvieto and the dark, powerful Sagrantino of Montefalco. This day is built for people who want to understand them, with private visits and tastings at a winery in each area.
      what_customers_think: "We collect Italian reds and have always wanted to taste Sagrantino where it is made."
      customer_name: "David"
      customer_origin: "Toronto, Canada"
      finer_details: |
        Your driver collects you in Rome and heads north to the vineyards around Orvieto. At the first winery, walk through cellars carved into the volcanic rock and taste Orvieto Classico with the winemaker.

        Then on to Montefalco, the balcony of Umbria, for lunch and a second private visit at a Sagrantino producer. Taste the dry red and the rare sweet passito, then take in the view from the town walls before the drive back to Rome.
      highlights:
        Orvieto Classico: Cellars cut into tufa and a tasting with the winemaker.
        Sagrantino di Montefalco: One of Italy’s most powerful reds, tasted at the source.
        Montefalco: A hilltop town known as the balcony of Umbria.
        Your own driver: Taste freely; the driving is taken care of.
      included:
        - Hotel pickup and drop-off in Rome
        - Private air-conditioned car and driver
        - Two winery visits and tastings
      excluded:
        - Lunch
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in central Rome. The first winery is about an hour and a half’s drive.
        Tasting: Guests must be 18 or older to taste.
        Buying wine: Both wineries can ship bottles home for you.
      prices: { private: 1390, max_guests: 6 }
      times: ["08:00"]

    - slug: orvieto-by-train-for-families
      code: 706
      title: Fun in Orvieto by Train from Rome
      tagline: Underground Caves and a Funicular Ride
      subtitle: A fun-filled train adventure from Rome to discover the magic of Orvieto.
      region: Umbria
      hours: 5
      transport: walking
      badge: with_kids
      meeting_point: Orvieto train station, at the funicular entrance
      languages: [en, es, fr, it]
      tags: [with_kids]
      photos: [countryside_palace.webp]
      what_we_think: |
        Orvieto is made for children: a funicular up the cliff, a city of caves underneath the streets, and a well so deep it has two staircases that never meet. Our family guide turns the day into an adventure, and the train from Rome is part of the fun.
      what_customers_think: "Our kids are 7 and 10 and get bored in churches. They still talk about the caves and the well."
      customer_name: "The Murphy family"
      customer_origin: "Dublin, Ireland"
      finer_details: |
        Take a morning train from Roma Termini to Orvieto. Your guide meets you at the station and rides up with you on the funicular to the top of the cliff.

        Explore Orvieto Underground, a maze of Etruscan caves, wells, and pigeon coops dug beneath the town, then walk down the double spiral staircase of St. Patrick’s Well. There’s time for a gelato and a look at the golden cathedral before the train back to Rome.
      highlights:
        The funicular: A ride straight up the cliff from the station.
        Orvieto Underground: Etruscan caves and tunnels beneath the town.
        St. Patrick’s Well: 248 steps down a double spiral staircase.
        Made for families: A guide who keeps children curious all day.
      included:
        - Licensed private family guide
        - Funicular tickets
        - Orvieto Underground entry
      excluded:
        - Train tickets from Rome
        - St. Patrick’s Well entry
        - Lunch
        - Gratuities
      facts:
        Meeting point: Orvieto station, at the funicular entrance. Send us your train time when you book.
        The train: Direct trains from Roma Termini take about an hour and a quarter.
        Pace: Lots of stairs in the caves and the well. Strollers can’t go underground.
      prices: { private: [420, 440, 460, 480, 500, 520] }
      times: ["10:00"]

    - slug: assisi-highlights-with-local-guide
      code: 707
      title: Highlights of Assisi with a Local Guide
      tagline: The Town of Saint Francis
      subtitle: The spiritual and artistic treasures of Assisi, its medieval landmarks and charming streets.
      region: Umbria
      hours: 3
      transport: walking
      meeting_point: Piazza Inferiore di San Francesco, in front of the lower basilica
      languages: [en, es, fr, it]
      tags: []
      photos: [assisi.webp]
      what_we_think: |
        If you’re staying in Umbria or already in Assisi, this is the best way to see it: three hours on foot with a guide who grew up here, from the Basilica of St. Francis to the quiet lanes most visitors never find.
      what_customers_think: "We were staying in Assisi for two nights and wanted someone to explain what we were seeing."
      customer_name: "Ana"
      customer_origin: "Lisbon, Portugal"
      finer_details: |
        Meet your guide in front of the Basilica of St. Francis. Start in the lower church, where the saint is buried, then climb to the upper church and Giotto’s cycle of frescoes on his life.

        Walk up through the old town to the Piazza del Comune and the Temple of Minerva, and on to the Basilica of St. Clare, home of the crucifix that spoke to Francis. The tour ends in the old town.
      highlights:
        Basilica of St. Francis: Giotto’s frescoes and the tomb of Italy’s patron saint.
        Basilica of St. Clare: The San Damiano crucifix and the tomb of St. Clare.
        Temple of Minerva: A Roman temple still standing on the main square.
        A local guide: Someone who grew up in Assisi and knows its quiet corners.
      included:
        - Licensed private guide
      excluded:
        - Transport to Assisi
        - Gratuities
      facts:
        Meeting point: Piazza Inferiore di San Francesco, in front of the lower basilica, 10 minutes before the start.
        Dress code: Shoulders and knees must be covered in the basilicas. Silence is requested in the lower church.
        Pace: Assisi is steep, with many stairs between the basilicas.
      prices: { private: [290, 310, 330, 350, 370, 390] }
      times: ["09:30", "14:00"]

    - slug: assisi-and-perugia-transfer-rome-florence
      code: 708
      title: Assisi and Perugia on a Transfer Tour between Rome and Florence
      tagline: Rome to Florence the Scenic Way
      subtitle: The spiritual treasures of Assisi and the historic charm of Perugia along the way from Rome to Florence.
      region: Umbria
      hours: 8
      transport: car
      badge: transfers
      meeting_point: Pickup from your hotel in central Rome (or Florence for the reverse journey)
      languages: [en, es, fr, it]
      tags: [transfers]
      photos: [assisi.webp, countryside_palace.webp]
      what_we_think: |
        The train between Rome and Florence takes 90 minutes and shows you nothing. This private transfer turns the journey into a day out, with stops in Assisi and Perugia on the way and your luggage safely in the car.
      what_customers_think: "We had to get from Rome to Florence anyway. Why not see Umbria on the way?"
      customer_name: "Rachel & Ben"
      customer_origin: "Manchester, UK"
      finer_details: |
        Your driver collects you and your luggage from your hotel in Rome and heads north into Umbria. In Assisi, a guide leads you through the Basilica of St. Francis and the old town.

        After lunch, continue to Perugia, Umbria’s capital, for a walk along the Corso Vannucci to the Fontana Maggiore and the cathedral square. Then it’s on to Florence, arriving at your hotel in the early evening. The same tour runs from Florence to Rome.
      highlights:
        Basilica of St. Francis: Giotto’s frescoes and the tomb of Italy’s patron saint.
        Perugia: Umbria’s hilltop capital and its Fontana Maggiore.
        Luggage stays with you: Your bags ride in the car all day.
        Door to door: From your hotel in Rome to your hotel in Florence.
      included:
        - Hotel pickup in Rome and drop-off in Florence
        - Private air-conditioned car and driver
        - Licensed guide in Assisi
        - Luggage handling
      excluded:
        - Lunch
        - Gratuities
      facts:
        Pickup: Your driver collects you from your hotel in central Rome. Tell us if you’d like to travel from Florence instead.
        Luggage: One large suitcase and one carry-on per guest. Let us know if you’re bringing more.
        Dress code: Shoulders and knees must be covered in the Basilica of St. Francis.
      prices: { private: 1490, max_guests: 6 }
      times: ["08:00"]
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
                   "what_customers_think", "customer_name", "customer_origin", "code", "badge").symbolize_keys,
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

      # Every Umbria tour is private: one price for up to max_guests, or a price per party size.
      prices = data["prices"]
      tickets =
        if prices["private"].is_a?(Array)
          prices["private"].map.with_index(1) do |price, guests|
            { name: "Private, #{guests} #{"guest".pluralize(guests)}", max_guests: guests, price_cents: price * 100 }
          end
        else
          [ { name: "Private group", max_guests: prices["max_guests"], price_cents: prices["private"] * 100 } ]
        end
      tickets.each_with_index { |ticket, position| tour.ticket_types.create!(ticket.merge(kind: "private", position:)) }

      data["photos"].each do |file|
        tour.photos.attach(io: Rails.root.join("app/assets/images/tours", file).open, filename: file, content_type: "image/webp")
      end

      created = Departures::Generator.call(tour:, kind: "private", times: data["times"], days: Departures::Generator::DAYS,
                                           capacity: 1, from:, to:, skip_dates: closed)
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
