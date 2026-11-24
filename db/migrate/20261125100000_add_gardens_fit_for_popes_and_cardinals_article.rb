# Adds the "Gardens Fit for Popes and Cardinals: Four Green Escapes from Rome" newsletter article: the Vatican Gardens,
# Castel Gandolfo, Villa d'Este in Tivoli and Villa Lante in Bagnaia. The content is frozen here so later edits
# elsewhere can't change what this migration does. If the post already exists it is left alone. There is no promo box:
# instead a tour for each garden is linked as a card at the end (only tours that exist in this database). Photos live in
# app/assets/images/newsletter. In the body, a line {{name}} becomes an inline photo: the image is uploaded as an Active
# Storage blob and embedded as an ActionText attachment with its caption.
class AddGardensFitForPopesAndCardinalsArticle < ActiveRecord::Migration[8.1]
  # The model as it was when this migration was written.
  class Article < ActiveRecord::Base
    self.table_name = "newsletter_articles"
    def self.polymorphic_name = "NewsletterArticle"

    has_rich_text :body
    has_one_attached :hero_image
  end

  class PromotedTour < ActiveRecord::Base
    self.table_name = "promoted_tours"
  end

  class Tour < ActiveRecord::Base
    self.table_name = "tours"
  end

  IMAGE_DIR = "app/assets/images/newsletter"

  ARTICLE = YAML.safe_load(<<~'YAML')
    slug: gardens-fit-for-popes-and-cardinals
    title: "Gardens Fit for Popes and Cardinals: Four Green Escapes from Rome"
    published_at: 2026-11-24 00:00
    excerpt: Rome’s holiest corners aren’t all indoors. Some of them have fountains. Four gardens made for popes and cardinals, from the Vatican Gardens to Villa Lante.
    meta_title: "Gardens of Popes and Cardinals: 4 Green Escapes from Rome"
    meta_description: "The Vatican Gardens, Castel Gandolfo, Villa d’Este in Tivoli and Villa Lante in Bagnaia: four papal and cardinals’ gardens in and around Rome."
    hero_image: papal-gardens-hero-villa-deste-tivoli.webp
    # One per garden, in the article's order.
    tours:
      - guided-vatican-gardens-skip-line-vatican-museums
      - roman-hills-and-winery
      - tivoli-and-hadrians-villa
      - rome-countryside-palaces-and-gardens
    images:
      vatican:
        file: papal-gardens-01-vatican-gardens.webp
        caption: The Vatican Gardens behind St. Peter’s Basilica
      gandolfo:
        file: papal-gardens-02-castel-gandolfo.webp
        caption: The papal palace of Castel Gandolfo above Lake Albano
      lante:
        file: papal-gardens-03-villa-lante-bagnaia.webp
        caption: The geometric parterre and Fountain of the Moors at Villa Lante, Bagnaia
    body: |
      <div><em>Rome’s holiest corners aren’t all indoors. Some of them have fountains.</em></div>
      <div>Rome is known for its basilicas and frescoes. But some of its most peaceful corners are gardens made for the princes of the Church. For centuries, popes and cardinals left the heat and noise of the city for fountains, shady oaks and cool terraces. Today you can walk where they did. Here are four to choose from.</div>
      <h2>1. The Vatican Gardens: the Pope’s Own Backyard</h2>
      {{vatican}}
      <div>Behind St. Peter’s Basilica, more than half of the world’s smallest state is green. Paths wind past formal Italian parterres, woodland, grottoes and fountains, with Michelangelo’s dome always in view. Popes have walked and prayed here since the Middle Ages. You’ll also pass the Lourdes Grotto replica, the Vatican’s own railway station and the Governorate Palace.</div>
      <div><strong>Good to know:</strong> The gardens can only be seen on a guided walking tour or an open minibus tour, and they sell out, so book early. Your ticket also gets you into the Vatican Museums and the Sistine Chapel the same day.</div>
      <h2>2. Castel Gandolfo: the Papal Summer Retreat</h2>
      {{gandolfo}}
      <div>High in the Alban Hills, above the deep blue crater of Lake Albano, sits the papal country estate. Its 135 acres are larger than Vatican City itself. The highlight is the Barberini Gardens, laid out in the 1600s by Taddeo Barberini, nephew of Pope Urban VIII. Expect clipped hedges, avenues of holm oaks, olive groves and terraces with sweeping views over the lake. Ruins of the Emperor Domitian’s villa are part of the estate. The tradition is alive again: Pope Leo XIV has brought back papal summer stays here. The town is lovely for lunch after your visit, too.</div>
      <div><strong>Good to know:</strong> About 25 km southeast of Rome, an easy half-day trip by train or car.</div>
      <h2>3. Villa d’Este, Tivoli: a Cardinal’s Water Wonderland</h2>
      <div>In the 1550s, Cardinal Ippolito II d’Este, son of Lucrezia Borgia, turned a former monastery into one of the most famous gardens in the world. Hundreds of fountains, pools and jets run down the hillside, all powered by gravity alone. Don’t miss the Avenue of the Hundred Fountains and the Fountain of the Organ, which still plays music with water. It’s a UNESCO World Heritage Site and the model for Renaissance gardens all over Europe.</div>
      <div><strong>Good to know:</strong> About 30 km east of Rome. Combine it with nearby Hadrian’s Villa for a full day.</div>
      <h2>4. Villa Lante, Bagnaia: the Hidden Jewel</h2>
      {{lante}}
      <div>Many garden lovers call this the most perfect garden in Italy, yet few visitors find it. Cardinal Gianfrancesco Gambara, Bishop of Viterbo, started it in 1566, with a design attributed to Vignola. Cardinal Alessandro Montalto, grand-nephew of Pope Sixtus V, finished it. Water tells the story as you walk downhill. It flows from a rustic grotto, along a stone “water chain” and across the Cardinal’s Table, where wine was chilled in a channel running through it. It ends in the Fountain of the Moors, set in a geometric parterre. There’s a story that Pope Gregory XIII saw how much the villa cost and cut the cardinal’s allowance.</div>
      <div><strong>Good to know:</strong> About an hour north of Rome near Viterbo. It’s quiet and uncrowded, ideal if you’d rather skip the tour buses.</div>
      <h2>Which One Is for You?</h2>
      <ul>
        <li><strong>Short on time?</strong> The Vatican Gardens, right in the city.</li>
        <li><strong>Want views and a slower pace?</strong> Castel Gandolfo.</li>
        <li><strong>Want to be amazed?</strong> Villa d’Este’s fountains.</li>
        <li><strong>A true garden lover?</strong> Villa Lante.</li>
      </ul>
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
    link_tours(article)
    say "#{article.title}: added"
  end

  def down
    article = Article.find_by(slug: ARTICLE["slug"]) or return
    PromotedTour.where(post_type: "NewsletterArticle", post_id: article.id).delete_all
    article.destroy!
  end

  private

  def link_tours(article)
    ARTICLE["tours"].each.with_index(1) do |slug, position|
      if (tour = Tour.find_by(slug: slug))
        PromotedTour.create!(post_type: "NewsletterArticle", post_id: article.id, tour_id: tour.id, position: position)
      else
        say "#{slug}: tour not found, not linked"
      end
    end
  end

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
