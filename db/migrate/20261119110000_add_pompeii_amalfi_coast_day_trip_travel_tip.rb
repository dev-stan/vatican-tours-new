# Adds the "Can You Visit Pompeii and the Amalfi Coast on a Day Trip from Rome?" travel tips guide, with its hero photo
# and five inline photos. The content is frozen here so later edits elsewhere can't change what this migration does. If
# the guide already exists it is left alone. Its booking button links the Pompeii, Amalfi Coast and Positano day trip
# from Rome, only if that tour exists in this database. Photos live in app/assets/images/travel-tips. In the body, a
# line {{name}} becomes an inline photo: the image is uploaded as an Active Storage blob and embedded as an ActionText
# attachment with its caption.
class AddPompeiiAmalfiCoastDayTripTravelTip < ActiveRecord::Migration[8.1]
  # The models as they were when this migration was written.
  class Guide < ActiveRecord::Base
    self.table_name = "travel_tips"
    def self.polymorphic_name = "TravelTip"

    has_rich_text :body
    has_one_attached :hero_image
  end

  class Promotion < ActiveRecord::Base
    self.table_name = "promoted_tours"
  end

  class Tour < ActiveRecord::Base
    self.table_name = "tours"
  end

  IMAGE_DIR = "app/assets/images/travel-tips"
  BOOKING_TOUR = "pompeii-amalfi-coast-positano"

  GUIDE = YAML.safe_load(<<~'YAML')
    slug: pompeii-and-amalfi-coast-day-trip-from-rome
    title: Can You Visit Pompeii and the Amalfi Coast on a Day Trip from Rome?
    published_at: 2026-11-17 00:00
    excerpt: Yes, if a high-speed train and a private driver do the heavy lifting. Here is exactly how to see Pompeii and the Amalfi Coast in one day from Rome, hour by hour.
    meta_title: "Pompeii & Amalfi Coast Day Trip from Rome: Hour by Hour"
    meta_description: "See Pompeii and the Amalfi Coast in one day from Rome: high-speed train, private driver and guide, with an hour-by-hour plan, tips and FAQ."
    hero_image: pompeii-amalfi-day-trip-hero-pompeii-vesuvius.webp
    button: Book the Pompeii, Amalfi Coast and Positano day trip
    images:
      train:
        file: pompeii-amalfi-day-trip-01-frecciarossa.webp
        caption: A Frecciarossa high-speed train gets you from Rome to Naples in about 70 minutes
      positano:
        file: pompeii-amalfi-day-trip-02-positano.webp
        caption: The colourful houses of Positano, stacked on the cliffside above the sea
      pompeii:
        file: pompeii-amalfi-day-trip-03-pompeii-vesuvius.webp
        caption: A street in Pompeii leading to the Forum, with Mount Vesuvius behind
      street:
        file: pompeii-amalfi-day-trip-04-pompeii-stepping-stones.webp
        caption: An ancient paved street in Pompeii, with its stepping stones still in place
      drive:
        file: pompeii-amalfi-day-trip-05-amalfi-drive.webp
        caption: The Amalfi Drive winding along the cliffs above the sea
    body: |
      <div>Yes, you can see Pompeii and the Amalfi Coast in a single day from Rome — if you let a high-speed train and a private driver do the heavy lifting. The trick is simple: a 70-minute train to Naples, a driver waiting on the platform, a private guide at the gates of Pompeii, and an afternoon on the most beautiful coastal road in Italy. No buses, no queues, no rental-car stress.</div>
      <div>Here is exactly how to plan it, hour by hour.</div>
      <h2>The plan at a glance</h2>
      <ul>
        <li><strong>Total time</strong>: about 12.5 hours, door to door from Rome</li>
        <li><strong>Train</strong>: Frecciarossa or Italo, Roma Termini → Napoli Centrale, about 1 h 10 min, direct</li>
        <li><strong>Driver</strong>: a private driver (NCC) meets you at Napoli Centrale and stays with you all day</li>
        <li><strong>Pompeii</strong>: 2 hours with a licensed private guide</li>
        <li><strong>Amalfi Coast</strong>: Positano photo stop, lunch, then Amalfi town</li>
        <li><strong>Return</strong>: your driver drops you at Salerno (or back in Naples) for the high-speed train to Rome</li>
        <li><strong>Best for</strong>: travellers based in Rome with only one free day for the south</li>
      </ul>
      <h2>Your day, hour by hour</h2>
      <div>This timing assumes a 7:30 train and works year-round; in summer, start even earlier to beat the heat.</div>
      <ul>
        <li><strong>7:30</strong> High-speed train leaves Roma Termini. Grab a cornetto and cappuccino on board.</li>
        <li><strong>8:40</strong> Arrive at Napoli Centrale. Your driver meets you with a name sign at the end of the platform.</li>
        <li><strong>9:20</strong> Arrive at Pompeii’s Porta Marina entrance and meet your private guide.</li>
        <li><strong>9:30–11:30</strong> Two-hour guided tour of Pompeii.</li>
        <li><strong>11:30</strong> Drive over the Lattari Mountains toward the coast (about 1 hour).</li>
        <li><strong>12:30</strong> Photo stop at the Positano viewpoint on the Amalfi Drive.</li>
        <li><strong>13:00</strong> Long lunch with a sea view, in Positano or Praiano.</li>
        <li><strong>15:00</strong> Continue along the coastal road to Amalfi town: cathedral, lemon shops, harbour stroll.</li>
        <li><strong>17:00</strong> Your driver takes you to Salerno station (about 40 minutes from Amalfi).</li>
        <li><strong>18:00–18:30</strong> High-speed train from Salerno to Rome.</li>
        <li><strong>About 20:00</strong> Back in Rome for a late dinner.</li>
      </ul>
      {{train}}
      {{positano}}
      <h2>Pompeii with a private guide</h2>
      <div>Pompeii covers about 66 hectares, and without a guide most visitors wander, miss the best houses and run out of time. A private guide turns two hours into a story: who lived here, how they ate, voted and gossiped, and what happened on that day in 79 AD.</div>
      <div><strong>What a good guide will show you in 2 hours:</strong></div>
      <ul>
        <li>The Forum, with Vesuvius framed behind the Temple of Jupiter</li>
        <li>The Stabian Baths and their stucco ceilings</li>
        <li>A thermopolium, Pompeii’s version of a street-food counter</li>
        <li>The House of the Faun and its famous mosaic floor</li>
        <li>Via dell’Abbondanza, the main street, still rutted by cart wheels</li>
        <li>The plaster casts of victims, the most moving moment of the visit</li>
      </ul>
      <div><strong>Tip:</strong> Ask your guide about the newest excavations in Regio V and Regio IX. Pompeii keeps revealing frescoes, and a good guide will know what’s newly open.</div>
      {{pompeii}}
      {{street}}
      <h2>The Amalfi Coast with a private driver</h2>
      <div>A private driver is the only stress-free way to see the coast in an afternoon. The Amalfi Drive (SS163) is narrow, cliff-hugging and packed in season, and parking in Positano or Amalfi can take longer than lunch.</div>
      <div><strong>Why a driver beats a rental car:</strong> In peak periods the coast road between Positano and Vietri sul Mare runs an odd/even licence-plate rule from 10:00 to 18:00. Licensed drivers with hire cars (NCC), taxis and buses are exempt; rental cars are not. The rule ends on 31 October each year and returns in spring.</div>
      <div><strong>The best stops, in order:</strong></div>
      <ol>
        <li><strong>Positano viewpoint</strong>: the classic postcard shot, a few minutes off the road.</li>
        <li><strong>Lunch in Positano or Praiano</strong>: fresh seafood, scialatielli pasta and a glass of local Falanghina.</li>
        <li><strong>Furore fjord</strong>: a quick look down at the tiny beach under the bridge.</li>
        <li><strong>Amalfi town</strong>: the striped Duomo and its 62 steps, lemon granita and a harbour walk.</li>
      </ol>
      {{drive}}
      <h2>FAQ</h2>
      <h3>Is it really possible to do Pompeii and the Amalfi Coast in one day from Rome?</h3>
      <div>Yes, with a high-speed train and a private driver. It is a long day of about 12.5 hours, but you see both highlights without changing transport.</div>
      <h3>How long is the train from Rome to Naples?</h3>
      <div>About 1 hour 10 minutes on a direct Frecciarossa or Italo train.</div>
      <h3>Do I need to book Pompeii tickets in advance?</h3>
      <div>Yes. Tickets are named, a cap of 20,000 visitors a day applies, and in high season entry is split into time slots.</div>
      <h3>Can I drive the Amalfi Coast myself instead?</h3>
      <div>You can, but rental cars fall under the summer odd/even plate rule, and parking is scarce. A licensed private driver is exempt and drops you right at each stop.</div>
      <h3>Is this trip suitable for children or older travellers?</h3>
      <div>Yes. The driver handles every transfer, and a private guide can shorten the Pompeii route and pick flatter streets.</div>
      <h2>Let Vatican Tours plan your day</h2>
      <div>You enjoy the day; we take care of every booking behind it. Vatican Tours can arrange the whole trip for you:</div>
      <ul>
        <li><strong>High-speed train tickets</strong>: Rome to Naples in the morning and Salerno to Rome in the evening, on the best-timed trains.</li>
        <li><strong>Private driver</strong>: waiting for you on the platform at Naples and with you all day, through to Salerno station.</li>
        <li><strong>Private guide in Pompeii</strong>: a licensed guide for a two-hour tour tailored to your group.</li>
        <li><strong>Timed admission tickets</strong>: your Pompeii entry booked in advance in your names, so you walk straight in.</li>
        <li><strong>Lunch with the best views</strong>: a reserved terrace table overlooking the Amalfi Coast.</li>
      </ul>
      <div>One booking, one point of contact, no logistics to worry about. <a href="/contact">Contact us to plan your Pompeii &amp; Amalfi Coast day trip</a>.</div>
  YAML

  def up
    if Guide.exists?(slug: GUIDE["slug"])
      say "#{GUIDE["slug"]}: already exists, skipped"
      return
    end

    guide = Guide.create!(
      **GUIDE.slice("slug", "title", "excerpt", "meta_title", "meta_description").symbolize_keys,
      body: body_with_images,
      published_at: Time.zone.parse(GUIDE["published_at"].to_s),
      status: "published"
    )
    guide.hero_image.attach(image_upload(GUIDE["hero_image"]))

    if (tour = Tour.find_by(slug: BOOKING_TOUR))
      Promotion.create!(post_type: "TravelTip", post_id: guide.id, tour_id: tour.id, label: GUIDE["button"])
    else
      say "#{BOOKING_TOUR}: tour not found, #{GUIDE["slug"]} saved without a booking button"
    end
    say "#{guide.title}: added"
  end

  def down
    return unless (guide = Guide.find_by(slug: GUIDE["slug"]))

    Promotion.where(post_type: "TravelTip", post_id: guide.id).delete_all
    guide.destroy!
  end

  private

  # Swaps each {{name}} placeholder for an ActionText attachment of the uploaded photo.
  def body_with_images
    GUIDE["body"].gsub(/\{\{(\w+)\}\}/) do
      image = GUIDE["images"].fetch(Regexp.last_match(1))
      blob = ActiveStorage::Blob.create_and_upload!(**image_upload(image["file"]))
      %(<action-text-attachment sgid="#{blob.attachable_sgid}" content-type="image/webp" ) +
        %(filename="#{ERB::Util.h(image["file"])}" caption="#{ERB::Util.h(image["caption"])}"></action-text-attachment>)
    end
  end

  def image_upload(file)
    { io: Rails.root.join(IMAGE_DIR, file).open, filename: file, content_type: "image/webp" }
  end
end
