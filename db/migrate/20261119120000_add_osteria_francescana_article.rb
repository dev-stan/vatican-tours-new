# Adds the "A Restaurant Worth Driving To: Osteria Francescana, Modena" newsletter article: the restaurant, Massimo
# Bottura, the menu, his Five Ageings of Parmigiano Reggiano recipe and what a meal there is like. The content is frozen
# here so later edits elsewhere can't change what this migration does. If the post already exists it is left alone.
# Instead of a tour, the article promotes the Naples, Pompeii and Amalfi Coast tab of the home page. Photos live in
# app/assets/images/newsletter. In the body, a line {{name}} becomes an inline photo: the image is uploaded as an Active
# Storage blob and embedded as an ActionText attachment with its caption.
class AddOsteriaFrancescanaArticle < ActiveRecord::Migration[8.1]
  # The model as it was when this migration was written.
  class Article < ActiveRecord::Base
    self.table_name = "newsletter_articles"
    def self.polymorphic_name = "NewsletterArticle"

    has_rich_text :body
    has_one_attached :hero_image
    has_one_attached :promo_image
  end

  IMAGE_DIR = "app/assets/images/newsletter"

  ARTICLE = YAML.safe_load(<<~'YAML')
    slug: osteria-francescana-modena
    title: "A Restaurant Worth Driving To: Osteria Francescana, Modena"
    published_at: 2026-11-19 00:00
    excerpt: Some meals are worth a detour. This one is worth the whole trip. Inside Massimo Bottura’s three-Michelin-star Osteria Francescana, with his recipe for the Five Ageings of Parmigiano Reggiano.
    meta_title: "Osteria Francescana, Modena: Massimo Bottura’s Restaurant"
    meta_description: Inside Massimo Bottura’s three-Michelin-star Osteria Francescana in Modena – menu, prices, a signature Parmigiano recipe and how to book.
    hero_image: osteria-francescana-hero-tasting-menu.webp
    promo_image: essential-naples.webp
    promo_url: /?region=naples-pompeii-and-amalfi-coast
    promo_title: Private Naples, Pompeii and Amalfi Coast Tours
    promo_text: |
      Pizza where it was born, the ruins of Pompeii beneath Vesuvius, and lemon-scented villages clinging to the Amalfi cliffs.

      Day trips from Rome, or a few unhurried days in the south – with local guides who know where to eat.
    promo_button: Explore our Naples and Amalfi tours
    images:
      corridor:
        file: osteria-francescana-01-art-corridor.webp
        caption: Contemporary art in the rooms of Osteria Francescana
      bottura:
        file: osteria-francescana-02-massimo-bottura.webp
        caption: Massimo Bottura in the streets of Modena
      parmigiano:
        file: osteria-francescana-03-parmigiano-reggiano.webp
        caption: Parmigiano Reggiano
      kitchen:
        file: osteria-francescana-04-bottura-in-the-kitchen.webp
        caption: Massimo Bottura in the kitchen of Osteria Francescana
      plate:
        file: osteria-francescana-05-five-ages-of-parmigiano.webp
        caption: Five Ageings of Parmigiano Reggiano
    body: |
      <div><em>Some meals are worth a detour. This one is worth the whole trip.</em></div>
      <h2>The Restaurant</h2>
      {{corridor}}
      <div>Tucked into a quiet, narrow lane in the historic centre of Modena, at Via Stella 22, Osteria Francescana doesn’t announce itself. There is no grand façade, no sweeping entrance – just a discreet door a short walk from the church of San Francesco, which gave the place its name back when it was a humble, inexpensive osteria in the 1950s. Step inside, though, and you are in one of the most celebrated dining rooms on the planet.</div>
      <div>Since opening in 1995, Osteria Francescana has collected nearly every honour fine dining has to offer: three Michelin stars held continuously since 2011 (plus a Michelin Green Star for sustainability), and two turns at number one on The World’s 50 Best Restaurants list, in 2016 and 2018. The rooms are calm and intimate, dressed in contemporary art rather than chandeliers, and the service is warm, playful and precise. It is a serious restaurant that refuses to take itself too seriously – and that balance is exactly what makes it special.</div>
      <div>The setting helps, too. Modena sits in the heart of Emilia-Romagna, Italy’s “food valley”: the home of Parmigiano Reggiano, traditional balsamic vinegar, Lambrusco and fresh egg pasta. It’s an easy drive from Bologna, about two hours from Milan, and roughly half an hour from Ferrari’s home in Maranello – the region likes to call itself the land of slow food and fast cars. Make a road trip of it.</div>
      <h2>The Chef: Massimo Bottura</h2>
      {{bottura}}
      <div>Massimo Bottura was born and raised in Modena, and his cooking is a long, affectionate conversation with the food he grew up on. He likes to say he cooks like a child – playing, asking questions, never settling. His genius lies in taking the most sacred dishes of Emilian tradition and looking at them from a new angle: compressing them, deconstructing them, poking gentle fun at them, and somehow making them taste even more like themselves.</div>
      <div>He is also famous for what he does outside the restaurant. Through his non-profit Food for Soul and its Refettorio community kitchens, Bottura turns surplus ingredients into meals for people in need, and he has served as a UN advocate against food waste. In 2025, as Osteria Francescana celebrated its 30th anniversary, the Italian government named him a “Master of the Art of Cuisine.” Together with his wife, Lara Gilmore, he has grown the “Francescana family” to include the countryside guesthouse Casa Maria Luigia, the casual Franceschetta58 in Modena and the wood-fire restaurant Al Gatto Verde – but the little osteria on Via Stella remains the heart of it all. As Bottura himself puts it, the restaurant belongs to the whole team, not just the man whose name is on the door.</div>
      <h2>The Menu</h2>
      <div>There are two ways to eat here. The headline experience is the tasting menu: 11 dishes for €350 per person, with an optional wine pairing of six wines for €240. The current menu carries names that hint at its sense of humour and curiosity – <em>Artusi</em> (a nod to Italy’s founding father of home cooking), <em>Where is this Pasta e Fagioli going next?!</em>, <em>Tagliatelle 10.0</em>, <em>Mediterraneo Contemporaneo</em>, <em>La Luce</em> and <em>L’Oscurità</em> (light and darkness) – and it changes over time, so expect surprises.</div>
      <div>There is also an à la carte menu, which is where many of Bottura’s legendary signatures live:</div>
      <ul>
        <li><strong>Five Ages of Parmigiano Reggiano</strong> – one cheese, aged for different lengths of time and served in different textures and temperatures. A love letter to Modena.</li>
        <li><strong>An eel swimming up the Po River</strong> – a tribute to the great river of northern Italy.</li>
        <li><strong>Modenese miniature tortellini</strong> in broth – tradition at its purest.</li>
        <li><strong>Tagliatelle al ragù</strong> – the region’s comfort classic, done perfectly.</li>
        <li><strong>Croccantino of foie gras</strong> – Bottura’s grown-up ice-cream bar.</li>
        <li><strong>Oops! I dropped the lemon tart</strong> – the famous “broken” dessert, inspired by a happy accident in the kitchen.</li>
      </ul>
      <div>Starters run from around €80, pastas from €80–110, mains from €110–150 and desserts €60, with an Italian cheese selection at €80. Either way, plan on a destination-level bill – and on remembering it for years.</div>
      <h2>Recipe: Five Ageings of Parmigiano Reggiano</h2>
      {{parmigiano}}
      <div><em>“Two ingredients, Parmigiano Reggiano and time: the chewable version of the slow aging process.”</em> Massimo Bottura recounts a dish that has become legendary.</div>
      <div>The initial idea was developed around the diversification of three consistencies, thus a mi-cuit, accompanied by a sauce and a biscuit, all starting from Parmigiano Reggiano. Further study subsequently resulted in a frozen foam, which stood apart from the rest due to its different temperature. Evolution then led to grafting the concept of aging into the preparation, which turned time into a fully-fledged ingredient.</div>
      <div>Thus, a 24-month cheese was used for the base cream and a 30-month one for the demi-soufflé. For the foam from the siphon, it was raised to 36 months, from 40-month crusts came the crispy biscuit, while the airy cloud covering it all involved a 50-month cheese.</div>
      <div><strong>Serves 4</strong></div>
      <h3>Parmigiano Reggiano Demi-Soufflé</h3>
      <ul>
        <li>200 g organic ricotta</li>
        <li>60 ml egg white</li>
        <li>100 g grated 24-month Parmigiano Reggiano</li>
        <li>40 ml cream</li>
        <li>1 g sea salt</li>
        <li>0.5 g white pepper</li>
      </ul>
      <div>In a smoker, with cherry wood, lightly smoke the ricotta for three minutes and then whisk it. Mix the Parmigiano Reggiano with the cream, add them to the ricotta, with salt and pepper. Fold in the whipped egg white and fill aluminum molds 4x8 cm previously buttered. Bake for 45 minutes, then remove the soufflés and shape them into quenelles.</div>
      <h3>Parmigiano Reggiano Sauce</h3>
      <ul>
        <li>20 ml unfiltered capon broth</li>
        <li>100 g grated 30-month Parmigiano Reggiano</li>
      </ul>
      <div>In a Thermomix, heat the broth to 60°C at medium speed, add the Parmigiano Reggiano, and bring to 85°C while blending and increasing the speed until obtaining a smooth sauce to strain through a chinois.</div>
      <h3>Parmigiano Foam</h3>
      <ul>
        <li>125 ml capon broth</li>
        <li>250 g grated 36-month Parmigiano Reggiano</li>
        <li>100 ml cream</li>
      </ul>
      <div>Bring the capon broth to a boil in the Thermomix at speed 3, gradually add the Parmigiano Reggiano, then the cream, increasing the speed for one minute, and cool to 4–8°C. Transfer the mixture to a siphon, shake it, charge with a double cartridge, and shake again. Let it rest in the refrigerator at 4–8°C for an hour.</div>
      <h3>Parmigiano Reggiano Biscuit</h3>
      <ul>
        <li>100 g grated 40-month Parmigiano Reggiano</li>
        <li>100 ml mineral water</li>
      </ul>
      <div>Slowly bring a pot of water to a boil with the Parmigiano Reggiano added, remove from heat when the cheese starts to shred, and let it sit for two hours. Strain the water and let the cheese rest overnight in the refrigerator. Preheat the oven to 170°C, stretch the cheese until it forms a 1 mm thick sheet, place it on a Silpat sheet, and bake for 12 minutes. Let it cool to room temperature and break it into approximately 5 cm triangular pieces.</div>
      <h3>Parmigiano Reggiano Air</h3>
      <ul>
        <li>200 g 50-month Parmigiano Reggiano rinds</li>
        <li>200 g grated 50-month Parmigiano Reggiano</li>
        <li>2 g lecithin</li>
      </ul>
      <div>Slowly simmer the Parmigiano Reggiano rinds in 500 ml of water for three hours, strain and let cool, add the grated cheese, whisk for 30 minutes, and let it rest overnight in the refrigerator. Strain through a flour sieve into a bowl, and at the time of service, add the lecithin and whisk with an electric whisk until obtaining an airy cloud.</div>
      <h3>Plate Composition</h3>
      {{kitchen}}
      {{plate}}
      <div>Place two quenelles of demi-soufflé in the center, arrange two spoonfuls of sauce around them, place the foam on one side, cover a quarter of the plate with the air, and insert the biscuit in the center, tilting it slightly.</div>
      <h2>What a Typical Lunch or Dinner Looks Like</h2>
      <div>You arrive in the evening (or at midday – more on that below) and are welcomed into one of the small, art-filled rooms. The pace is unhurried from the very start. A few small bites and bread arrive while you settle in with a glass of something sparkling and a look at the menu.</div>
      <div>Then the show begins. On the tasting menu, dishes arrive one by one over roughly three to four hours, each introduced by the staff with a story: where the idea came from, which childhood memory or piece of Italian history it plays with, why it looks the way it does. Expect a journey that starts light and vegetal, moves through pasta – always a highlight in Emilia – into richer fish and meat courses, and finishes with desserts that are as witty as they are delicious. Some plates look like modern art; others look deceptively simple until you taste them. The wine pairing leans heavily on Italian producers, and the sommeliers are happy to steer you toward a great Lambrusco or a serious bottle from the cellar.</div>
      <div>If you go à la carte, the rhythm is similar but shorter: a starter, a pasta, a main and dessert – and if it’s your first visit, we’d suggest building it around the classics, with the Five Ages of Parmigiano and the lemon tart non-negotiable.</div>
      <div><strong>Lunch vs. dinner:</strong> lunch is a lovely choice. It tends to be quieter and slightly easier to book, yet the cooking is exactly as ambitious, and you’ll walk out into the Modena afternoon with time for a stroll past the cathedral or a visit to a balsamic vinegar producer. Dinner is more of an occasion – dress up a little and make it the night of the trip.</div>
      <h2>Before You Go</h2>
      <ul>
        <li><strong>Book early.</strong> Tables are released online months in advance, at 10:00 a.m. Italian time on set dates – for example, June 2027 tables open on 1 December 2026 and July 2027 tables on 4 January 2027. Check <a href="https://www.osteriafrancescana.it">osteriafrancescana.it</a> for the current schedule.</li>
        <li><strong>Can’t get a table?</strong> Francescana at Maria Luigia, at Bottura’s countryside estate just outside Modena, serves a nine-course menu of the restaurant’s most iconic historic dishes (€330 per person, €170 beverage pairing).</li>
        <li><strong>Make a weekend of it.</strong> Pair your meal with a Parmigiano dairy tour at dawn, an acetaia (balsamic vinegar house) visit, and a glass of Lambrusco in Piazza Grande.</li>
      </ul>
      <div><strong>Yes, it’s a drive. And yes, it’s worth every kilometre.</strong></div>
      <div><em>Prices and menus as listed by the restaurant in November 2026; both change, so please confirm before you book.</em></div>
  YAML

  def up
    if Article.exists?(slug: ARTICLE["slug"])
      say "#{ARTICLE["slug"]}: already exists, skipped"
      return
    end

    article = Article.create!(
      **ARTICLE.slice("slug", "title", "excerpt", "meta_title", "meta_description",
                      "promo_url", "promo_title", "promo_text", "promo_button").symbolize_keys,
      body: body_with_images,
      published_at: Time.zone.parse(ARTICLE["published_at"].to_s),
      status: "published"
    )

    article.hero_image.attach(image_upload(IMAGE_DIR, ARTICLE["hero_image"]))
    article.promo_image.attach(image_upload("app/assets/images/tours", ARTICLE["promo_image"]))
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
