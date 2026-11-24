# Adds the "Baia: The Roman Resort You Visit in a Wetsuit" newsletter article: ancient Baiae, bradyseism and the
# Underwater Archaeological Park of Baia. The content is frozen here so later edits elsewhere can't change what this
# migration does. If the post already exists it is left alone. There is no promo box and no linked tour for now. Photos
# live in app/assets/images/newsletter. In the body, a line {{name}} becomes an inline photo: the image is uploaded as
# an Active Storage blob and embedded as an ActionText attachment with its caption.
class AddBaiaUnderwaterParkArticle < ActiveRecord::Migration[8.1]
  # The model as it was when this migration was written.
  class Article < ActiveRecord::Base
    self.table_name = "newsletter_articles"
    def self.polymorphic_name = "NewsletterArticle"

    has_rich_text :body
    has_one_attached :hero_image
  end

  IMAGE_DIR = "app/assets/images/newsletter"

  ARTICLE = YAML.safe_load(<<~'YAML')
    slug: baia-roman-resort-you-visit-in-a-wetsuit
    title: "Baia: The Roman Resort You Visit in a Wetsuit"
    published_at: 2026-11-24 00:00
    excerpt: Most ancient sites ask you to stay behind the rope. This one asks you to bring fins. Inside the Underwater Archaeological Park of Baia, west of Naples.
    meta_title: "Baia Underwater Park: The Roman Resort Beneath the Sea"
    meta_description: "Snorkel or dive over Roman villas, mosaics and statues at the Underwater Archaeological Park of Baia near Naples, a town sunk by the breathing ground."
    hero_image: baia-hero-dionysus-statue-snorkeller.webp
    images:
      mosaic:
        file: baia-01-bikini-girls-mosaic.webp
        caption: Roman leisure in mosaic, the “bikini girls” of the Villa Romana del Casale in Sicily
      sunken:
        file: baia-02-sunken-town-illustration.webp
        caption: Roman Baiae beneath the waves, as imagined in a digital illustration
      solfatara:
        file: baia-03-solfatara-crater.webp
        caption: The Solfatara crater at Pozzuoli, part of the Campi Flegrei caldera
      statue:
        file: baia-04-nymphaeum-dionysus-statue.webp
        caption: A copy of the Dionysus statue from the Nymphaeum of Claudius, in place on the seabed
      snorkel:
        file: baia-05-snorkelling-tour.webp
        caption: Snorkellers in the Underwater Archaeological Park of Baia
      castle:
        file: baia-06-castle-view-over-the-bay.webp
        caption: The view from Baia’s castle, home of the Archaeological Museum of the Campi Flegrei
    body: |
      <div><em>Most ancient sites ask you to stay behind the rope. This one asks you to bring fins.</em></div>
      <div>Just west of Naples, in the volcanic landscape of the Campi Flegrei, there is an archaeological park where the main street, the villas and the mosaic floors lie a few metres under the sea. You don’t walk through it. You float over it, snorkel above it, or dive down to it. It is the <strong>Underwater Archaeological Park of Baia</strong>, and there is very little else like it anywhere in the world.</div>
      <h2>The Las Vegas of Ancient Rome</h2>
      {{mosaic}}
      <div>Two thousand years ago, Baiae (as the Romans called it) was where the empire’s elite went to relax. Senators, emperors and the very rich built seaside villas here, soaked in hot springs fed by the volcano under their feet, and threw parties that scandalised the moralists of the day. The poet Propertius described it as a den of vice. Nearby sat Portus Julius, a major naval harbour, and across the bay at Misenum, the imperial fleet.</div>
      <div>In other words, this was not a sleepy fishing village. It was the place to be seen.</div>
      <h2>A Town That Sank Slowly</h2>
      {{sunken}}
      <div>What makes Baia unusual isn’t a single catastrophe. Pompeii was buried in a day. Baia drowned over centuries.</div>
      <div>The culprit is <strong>bradyseism</strong>, a slow rising and falling of the ground caused by the magma and hot fluids moving beneath the Campi Flegrei caldera. Over the centuries after the empire’s decline, the coastline here sank by several metres, and the sea gradually moved in over streets, baths and gardens. The water that swallowed Baia is also what preserved it: shielded from builders, farmers and looters, much of the town stayed where it was.</div>
      <div>The ground is still moving today. In fact, the same process can run in reverse. In the area around nearby Lake Fusaro, rising ground has recently brought the remains of a Roman villa back into view. Baia is not a frozen ruin. It is a site on a living volcano.</div>
      <h2>Bradyseism: the Breathing Ground</h2>
      {{solfatara}}
      <div>Bradyseism (<em>bradisismo</em> in Italian) is not a conventional earthquake. It is a gradual raising and lowering of the ground, caused by volcanic activity underground. In the last half-century it has been measured closely around Pozzuoli, and the figures show just how far the ground can travel:</div>
      <ul>
        <li><strong>1970–1972:</strong> the ground rose by about 1.7 metres.</li>
        <li><strong>1982–1984:</strong> the most dramatic modern episode. The ground rose by approximately 1.8–1.9 metres, accompanied by thousands of earthquakes, the strongest reaching magnitude 4.0. Thousands of residents had to be evacuated.</li>
        <li><strong>1985–2005:</strong> only then did the sinking come, as the ground gradually subsided by approximately 94 cm.</li>
      </ul>
      <div>In other words, the fall did not cancel out the rise: two decades of sinking undid only about half of the early-1980s uplift. Repeated over many centuries, with the falls outweighing the rises, this same slow motion is what put Roman Baia beneath the sea.</div>
      <div><em>Source: <a href="https://rischi.protezionecivile.gov.it">Italian Civil Protection</a></em></div>
      <h2>What’s Down There</h2>
      {{statue}}
      <div>The protected area was established in 2002 and stretches along the coast from the harbour at Baia towards Pozzuoli, in water that gets no deeper than about 15 metres. Much of it is far shallower, which is why snorkellers can see so much. Highlights include:</div>
      <ul>
        <li><strong>The Nymphaeum of Claudius</strong>, a grand dining hall built for the emperor, with statues lining its walls. The statues you see underwater are faithful copies; the originals were raised and are now in the Archaeological Museum of the Campi Flegrei, inside the hilltop castle at Baia.</li>
        <li><strong>Villa a Protiro</strong>, a villa with a porched entrance and well-preserved mosaic and marble floors.</li>
        <li><strong>Villa dei Pisoni</strong>, believed to have belonged to the powerful Piso family before passing into imperial hands.</li>
        <li><strong>Portus Julius</strong>, the remains of the naval and commercial harbour, with its piers and warehouses.</li>
      </ul>
      <div>And the discoveries keep coming. In recent years archaeologists have uncovered a marble floor from a seaside residence and, in 2025, a well-preserved bathhouse.</div>
      <h2>Archaeology Meets Marine Biology</h2>
      <div>The other thing that makes Baia special is that it’s both an archaeological site and a nature reserve. Columns and walls have become reefs. Octopuses hide in Roman pipes, sponges and sea fans cling to the brickwork, and fish dart through doorways that once led into dining rooms. It’s one of the few places where a history lesson and a wildlife encounter happen in the same breath.</div>
      <h2>How to See It</h2>
      {{snorkel}}
      <div>You don’t need to be a diver:</div>
      <ul>
        <li><strong>Glass-bottom boats</strong> leave from the port of Baia and let you look down on the ruins while staying dry.</li>
        <li><strong>Snorkelling tours</strong> cover the shallow areas, where many of the floors and walls are just a few metres down.</li>
        <li><strong>Guided dives</strong> take certified divers (and beginners on introductory programmes) to the deeper sites. All visits within the park are with authorised local operators.</li>
      </ul>
      {{castle}}
      <div>Pair it with the land-based Archaeological Park of the Baths of Baia and the castle museum, and you have a full day that starts on a terrace overlooking the sea and ends underneath it.</div>
      <h2>Why It Stays with You</h2>
      <div>Most ruins tell you how people lived. Baia also tells you how the earth itself moves, slowly, patiently, and without asking permission. Swimming above a Roman mosaic floor, with fish where the guests used to recline, is a strange and quiet reminder that even the most glamorous places are only ever borrowed from the landscape.</div>
      <div>If you find yourself near Naples, skip one more pizza queue and go and see it. Bring a mask.</div>
  YAML

  def up
    if Article.exists?(slug: ARTICLE["slug"])
      say "#{ARTICLE["slug"]}: already exists, skipped"
      return
    end

    article = Article.create!(
      **ARTICLE.slice("slug", "title", "excerpt", "meta_title", "meta_description").symbolize_keys,
      body: body_with_images,
      published_at: Time.zone.parse(ARTICLE["published_at"].to_s),
      status: "published"
    )

    article.hero_image.attach(image_upload(ARTICLE["hero_image"]))
    say "#{article.title}: added"
  end

  def down
    Article.find_by(slug: ARTICLE["slug"])&.destroy!
  end

  private

  # Swaps each {{name}} placeholder for an ActionText attachment of the uploaded photo.
  def body_with_images
    ARTICLE["body"].gsub(/\{\{(\w+)\}\}/) do
      image = ARTICLE["images"].fetch(Regexp.last_match(1))
      blob = ActiveStorage::Blob.create_and_upload!(**image_upload(image["file"]))
      %(<action-text-attachment sgid="#{blob.attachable_sgid}" content-type="image/webp" ) +
        %(filename="#{ERB::Util.h(image["file"])}" caption="#{ERB::Util.h(image["caption"])}"></action-text-attachment>)
    end
  end

  def image_upload(file)
    { io: Rails.root.join(IMAGE_DIR, file).open, filename: file, content_type: "image/webp" }
  end
end
