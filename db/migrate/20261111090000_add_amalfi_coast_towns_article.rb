# Adds the Amalfi Coast towns newsletter article. The content is frozen here so later edits elsewhere can't change what this
# migration does. If the post already exists it is left alone. The promoted tour is linked only if it exists in this
# database. Photos live in app/assets/images/newsletter. In the body, a line {{name}} becomes an inline photo: the
# image is uploaded as an Active Storage blob and embedded as an ActionText attachment with its caption.
class AddAmalfiCoastTownsArticle < ActiveRecord::Migration[8.1]
  # The model as it was when this migration was written. The app model has since been renamed to NewsletterArticle
  # (and the table to newsletter_articles, in a later migration), so this one keeps the old table and record_type.
  class Article < ActiveRecord::Base
    self.table_name = "articles"
    def self.polymorphic_name = "Article"

    belongs_to :tour, optional: true
    has_rich_text :body
    has_one_attached :hero_image
    has_one_attached :tour_image
  end

  # Attachments and rich text find their owner by record_type ("Article"), including in after-commit callbacks, so that
  # name has to resolve while migrations run. Nothing in the app is called Article any more.
  Object.const_set(:Article, Article) unless Object.const_defined?(:Article)

  IMAGE_DIR = "app/assets/images/newsletter"

  ARTICLE = YAML.safe_load(<<~'YAML')
    slug: amalfi-coast-towns
    title: Which Towns on the Amalfi Coast Should You Visit?
    published_at: 2026-11-11 00:00
    excerpt: There’s so much more to see than just Positano. Here’s what to expect from each of the 13 towns along the Amalfi Coast.
    hero_image: positano.webp
    tour_image: amalfi-coast.webp
    tour: amalfi-coast-positano-amalfi-ravello
    images:
      coast_road:
        file: amalfi-coast-road.webp
        caption: The coast road, carved into the cliffs above the sea
      praiano:
        file: praiano-marina-di-praia.webp
        caption: The beach at Marina di Praia, Praiano
      furore:
        file: furore-vineyards.webp
        caption: Terraced vineyards above the sea near Furore
      conca:
        file: conca-dei-marini-emerald-grotto.webp
        caption: The Grotta dello Smeraldo, Conca dei Marini
      limoncello:
        file: amalfi-limoncello.webp
        caption: Limoncello for sale in Amalfi
      atrani:
        file: atrani.webp
        caption: Atrani and its majolica-domed Collegiate Church
      ravello:
        file: ravello-villa-rufolo.webp
        caption: The gardens of Villa Rufolo, Ravello
      scala:
        file: scala.webp
        caption: Scala, among its terraced hillsides
      minori:
        file: minori-basilica-santa-trofimena.webp
        caption: The Basilica of Santa Trofimena, Minori
      maiori:
        file: maiori.webp
        caption: The long beach at Maiori
      cetara:
        file: cetara.webp
        caption: The fishing harbor at Cetara
      vietri:
        file: vietri-sul-mare.webp
        caption: Vietri sul Mare at dusk
    body: |
      <div>There’s so much more to see than just Positano.</div>
      <div>The ribbon of coastline known as the Costiera Amalfitana (Amalfi Coast) attracts some five million tourists annually. The towns of Positano and Amalfi get the lion’s share of visitors and offer five-star hotels, beach clubs, and myriad souvenir shops. There are 13 localities along the shore or clinging to the cliffside, each with a different character and unique attractions. Here’s what to expect from each.</div>
      {{coast_road}}
      <h2>Positano</h2>
      <div>Positano’s pastel-colored, flower-bedecked houses that cascade down the cliffside to the shore are a photographer’s dream — it’s no wonder the town has acted as the backdrop for romantic movies from <em>Under the Tuscan Sun</em> to the musical <em>Nine</em>. This is one of the Amalfi Coast’s chicest locations, with storied hotels like Le Sirenuse and glam beach clubs like Arienzo. It is not without culture either. Visit the Church of Santa Maria Assunta for a restored Byzantine icon of the Virgin Mary and a shimmering tiled dome.</div>
      <h2>Praiano</h2>
      <div>The stretch of serpentine road between Positano and Amalfi is one of the most frequented by tourists, but few stop at the towns on the way. Praiano is more peaceful and understated than its tourist-flooded neighbors. It has a small beach hugged by teetering cliffs and houses dotted among the green ridge of Monte Sant’Angelo above. Inside the Church of San Giovanni Battista, you’ll find a pristine majolica tiled floor dating back centuries. You’ll still find upmarket hotels and waterside dining in Praiano, and you’re less likely to miss out if you try to book at the last minute.</div>
      {{praiano}}
      <h2>Furore</h2>
      <div>This tiny hamlet is rarely visited, and you sometimes have to request it as a stop on the local buses. It may be minute, but it is designated as one of the most beautiful villages in Italy. There is no central square or high street here. It is separated into two parts: fishermen’s cottages and an ex-paper mill (now an Ecomuseum) that flank either side of a deep fjord and a sprinkling of houses clinging to the cliffside above. To reach the beach and cobalt water, you have to climb down 200 steps from the coastal highway. For the upper hamlet, there are 3000 steps leading to its mural-decorated houses and historic churches.</div>
      {{furore}}
      <h2>Conca dei Marini</h2>
      <div>The hillside Conca dei Marini was first settled by the Etruscans. Retaining its identity as a fishing hamlet, it is one of the best places on the Amalfi Coast for seafood restaurants, including the Michelin-starred il Refettorio. It is also the birthplace of the <em>sfogliatella Santa Rosa</em>, a shell-shaped flaky pastry invented in the 17th century by the nuns of the convent of Santa Rosa da Lima. At water level, you can find the entrance to the Grotta dello Smeraldo, a 30-meter-high karst cave that is bathed in an emerald green glow when sunlight penetrates through the underwater fissure.</div>
      {{conca}}
      <h2>Amalfi</h2>
      <div>Amalfi is a crowded, lively town and the main transport hub for the coastline, with a bus terminal and ferry dock. Once a powerful marine republic, it was decimated by invaders and a tsunami in 1343 and never recovered its former prestige. It has a beachside promenade packed with bars and a central square crammed with outdoor dining tables and presided over by the 9th-century Duomo di Amalfi, a church where Arab-Norman, Romanesque, Byzantine, and Rococo designs collide.</div>
      <div>You’ll find famed hotels like Hotel Santa Caterina and Anantara Convento di Amalfi with magnificent views. Walk past the souvenir shops along the high street, and you’ll reach a paper museum showcasing ancient production methods. Further up is one of the few remaining lemon terraces still in use, which you can visit with the Amalfi Lemon Experience and sample lemon cake and limoncello liqueur.</div>
      {{limoncello}}
      <h2>Atrani</h2>
      <div>Squeezed in beside Amalfi, this pint-sized town is easily overshadowed by its neighbor. However, it boasts the accolade of being the municipality in Italy with the smallest surface area (0.12 km²). Its labyrinthine staircases, covered passageways, and stage set-like squares are a delight to wander around. Visit the Church of San Salvatore de’ Birecto, where the Republic of Amalfi’s doges were once crowned, and the majolica-domed Collegiate Church of Santa Maria Maddalena for a breathtaking view.</div>
      {{atrani}}
      <h2>Ravello</h2>
      <div>Ravello is the town for romantics, a hillside hamlet of storybook villas creeping with ivy and bougainvillea-framed views. It has historically been a muse for painters, poets, and musicians and provided a summer retreat for the affluent. Dream over the cliffside Italianate gardens of the 13th-century Villa Rufolo and the flower-draped walks of Villa Cimbrone. The latter is also the location of the legendary Terrace of Infinity, a belvedere lined with marble busts overlooking the vast expanse of the Tyrrhenian Sea.</div>
      {{ravello}}
      <h2>Scala</h2>
      <div>Head a little further up the mountainside, and you come to Scala, the oldest town along the Amalfi Coast. It sits 400 meters above sea level on a narrow ridge from which slope steep terraces of lemon groves. The town is actually a clutch of tiny <em>frazioni</em>, or hamlets, whose few houses are centered around a little piazza and a historic church. The imposing 12th-century Duomo di San Lorenzo, with its ornate Baroque stuccoes and tiled interior, hints at the now-lost grandeur of the community and wealth of the resident merchant families.</div>
      {{scala}}
      <h2>Minori</h2>
      <div>Back down on the water’s edge, uncrowded Minori has a quiet, local feel with none of the pretension that sometimes slips into hospitality in other areas along the coastline. There’s a small beach with toes-in-the-sand bars and informal trattorias along the promenade. Visit the remains of the Villa Marittima Romana, an ancient Roman patrician residence dating back to the 1st century AD, and the Basilica of Santa Trofimena with an altar embellished with multi-colored marble inlays.</div>
      {{minori}}
      <h2>Maiori</h2>
      <div>You can walk to neighboring Maiori via the Path of the Lemons, a walking route around the hillside that weaves between and often ducks under the citrus groves heavy with fragrant fruit. With a longish stretch of beach (at least for the Amalfi Coast), it has the feel of a family-friendly summer resort, something it has actually been since Roman times. Catastrophic floods in 1954 razed the historic center, so you’ll find modern apartment blocks and wider, treelined streets here.</div>
      {{maiori}}
      <h2>Tramonti</h2>
      <div>If you start in the center of Maiori with your back to the sea and head up the mountainside, you will reach the verdant town of Tramonti. This mountain outpost seems worlds away from the summery coastline, set high in the velvet green Monti Lattari. You’ll find olive groves, vineyards, vegetable gardens, and crisp, cool air all summer long. Nearby Naples may be the home of pizza, but Tramonti has its own certified variation using locally made fiordilatte cheese.</div>
      <h2>Cetara</h2>
      <div>Cetara remains a quintessential Campanian fishing village with brightly-colored boats bobbing in the harbor and two legendary fish products. <em>Colatura di Alici</em> is a syrupy fermented anchovy sauce (similar to the Ancient Roman garum) that is used to flavor grilled vegetables, top pasta, or drizzle on pizza. Cetara’s fresh tuna is also highly regarded (and exported as far as Japan). As one of the Amalfi Coast’s towns that is least dependent on tourism, it is a glimpse into how the coastline was before the economy turned to hospitality.</div>
      {{cetara}}
      <h2>Vietri sul Mare</h2>
      <div>Vietri sul Mare is the westernmost town on the Amalfi Coast, and its railway station makes it easy to reach from other destinations in Italy by train. The town is the home of the coast’s eye-popping ceramic production, which began here in the Middle Ages. Visit the Museo della Ceramica to find out more about this majolica production, and stop by the 18th-century Church of San Giovanni Battista to see some in situ on the dome. Wander the historic center, and you’ll find rainbow-hued houses bright with pottery decorations and vividly tiled shop fronts. If that’s not enough ceramic, visit the Villa Comunale di Vietri for a Gaudí-esque tiled terrace.</div>
      {{vietri}}
      <div><em>Source: <a href="https://www.fodors.com/world/europe/italy/amalfi-coast/experiences/news/photos/which-towns-in-amalfi-coast-should-i-visit">Fodor’s Travel</a></em></div>
  YAML

  def up
    if Article.exists?(slug: ARTICLE["slug"])
      say "#{ARTICLE["slug"]}: already exists, skipped"
      return
    end

    tour = Tour.find_by(slug: ARTICLE["tour"])
    say "#{ARTICLE["tour"]}: tour not found, article saved without a promoted tour" unless tour

    article = Article.create!(
      **ARTICLE.slice("slug", "title", "excerpt").symbolize_keys,
      body: body_with_images,
      published_at: Time.zone.parse(ARTICLE["published_at"].to_s),
      tour:,
      status: "published"
    )

    article.hero_image.attach(image_upload(IMAGE_DIR, ARTICLE["hero_image"]))
    article.tour_image.attach(image_upload("app/assets/images/tours", ARTICLE["tour_image"]))
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
      blob = ActiveStorage::Blob.create_and_upload!(**image_upload(IMAGE_DIR, image["file"]))
      %(<action-text-attachment sgid="#{blob.attachable_sgid}" content-type="image/webp" ) +
        %(filename="#{ERB::Util.h(image["file"])}" caption="#{ERB::Util.h(image["caption"])}"></action-text-attachment>)
    end
  end

  def image_upload(dir, file)
    { io: Rails.root.join(dir, file).open, filename: file, content_type: "image/webp" }
  end
end
