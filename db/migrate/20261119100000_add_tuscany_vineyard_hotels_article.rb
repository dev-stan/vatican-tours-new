# Adds the "Eye on Italy: Tuscany's Most Beautiful Vineyard Hotels" newsletter article, based on The Times's
# "20 of the best vineyard hotels in Tuscany". The content is frozen here so later edits elsewhere can't change what this
# migration does. If the post already exists it is left alone. Instead of a tour, the article promotes the Tuscany tab of
# the home page (/?region=tuscany). Photos live in app/assets/images/newsletter. In the body, a line {{name}} becomes an
# inline photo: the image is uploaded as an Active Storage blob and embedded as an ActionText attachment with its caption.
class AddTuscanyVineyardHotelsArticle < ActiveRecord::Migration[8.1]
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
    slug: tuscany-most-beautiful-vineyard-hotels
    title: "Eye on Italy: Tuscany’s Most Beautiful Vineyard Hotels"
    published_at: 2026-11-18 00:00
    excerpt: From historic castles above the Val d’Orcia to Chianti wine estates and Maremma retreats, The Times picks 20 of Tuscany’s finest vineyard hotels.
    meta_title: Tuscany’s Most Beautiful Vineyard Hotels | Eye on Italy
    meta_description: The Times picks 20 of Tuscany’s finest vineyard hotels, from Val d’Orcia castles to Chianti wine estates, plus how to taste Tuscany in a single day.
    hero_image: tuscany-vineyard-hotels-hero.webp
    promo_image: tuscan-winery.webp
    promo_url: /?region=tuscany
    promo_title: Private Tuscany Tours and Winery Experiences
    promo_text: |
      Scenic drives through Chianti and the Val d’Orcia, medieval hill towns, and private visits to carefully selected wineries, where you taste the wines with the people who make them.

      Day trips from Florence or Rome, or on your way between the two.
    promo_button: Explore our Tuscany tours
    images:
      villa:
        file: tuscany-vineyard-hotels-01-villa-vignamaggio.webp
        caption: Villa Vignamaggio, a historic wine estate in Chianti
    body: |
      <div><em>Eye on Italy: the stories worth discovering from the international press.</em></div>
      <blockquote><strong>“20 of the Best Vineyard Hotels in Tuscany”</strong><br>This feature is based on an article by <a href="https://www.thetimes.com/profile/mia-aimaro-ogden">Mia Aimaro Ogden</a> and Marina Spironetti, Italy experts, originally published in <em>The Times</em> on Tuesday, 18 August 2026.</blockquote>
      <div>Tuscany is synonymous with rolling vineyards, medieval villages, cypress-lined roads and some of Italy’s finest wines. But for travellers seeking something beyond traditional wine tastings and cellar tours, the region offers an extraordinary collection of vineyard hotels where wine, landscape, gastronomy and hospitality come together.</div>
      <div>From historic castles overlooking the Val d’Orcia to elegant wine estates in Chianti and luxurious countryside retreats in the Maremma, these properties offer a wonderful way to experience the Tuscan lifestyle.</div>
      <div>A recent selection by <em>The Times</em> explores 20 of Tuscany’s finest vineyard hotels, highlighting exceptional places to stay for wine lovers, food enthusiasts and travellers looking for an authentic connection with the region.</div>
      <div>It is an inspiring selection for anyone planning a stay in Tuscany, whether dreaming of a romantic escape, a gourmet holiday or a few days immersed in the beauty of the Italian countryside.</div>
      {{villa}}
      <h2>Tuscany in a Day</h2>
      <div>Dreaming of Tuscany but don’t have several days to explore its vineyards and wine estates? Even with limited time, you can experience the region’s extraordinary landscapes, charming medieval towns and celebrated wine traditions.</div>
      <div>At Vatican Tours, we create private excursions throughout Tuscany, combining scenic drives, visits to picturesque villages and carefully selected wineries where you can discover local wines and meet the people behind them.</div>
      <div>Whether you have just a few hours in Florence, a free day in Rome, or are travelling between Florence and Rome, we can arrange a tailor-made experience that brings you closer to the real Tuscany. Enjoy a private winery visit and wine tasting, explore the rolling hills of Chianti or the Val d’Orcia, discover historic wine towns, and savour the flavours of the region without having to plan an extended stay.</div>
      <div><strong>You don’t need a week in Tuscany to experience its wine culture. Sometimes one memorable day is all it takes.</strong></div>
      <div>Explore our <a href="/?region=tuscany">private Tuscany tours and winery experiences</a> – and let us help you make the most of your time in Italy.</div>
      <div><em><a href="https://www.thetimes.com/travel/destinations/europe-travel/italy/tuscany/best-vineyard-hotels-in-tuscany-p3jmgsqq9">Read the original article in The Times →</a></em></div>
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
