# Adds the "In Search of Italy's Best Mozzarella: A Pilgrimage to Tenuta Vannulo" newsletter article: a guide to buffalo
# mozzarella and the organic Palmieri family farm near Paestum. The content is frozen here so later edits elsewhere
# can't change what this migration does. If the post already exists it is left alone. The article has only a hero photo
# (in app/assets/images/newsletter), no inline photos, and no promo box or linked tours.
class AddTenutaVannuloMozzarellaArticle < ActiveRecord::Migration[8.1]
  # The model as it was when this migration was written.
  class Article < ActiveRecord::Base
    self.table_name = "newsletter_articles"
    def self.polymorphic_name = "NewsletterArticle"

    has_rich_text :body
    has_one_attached :hero_image
  end

  IMAGE_DIR = "app/assets/images/newsletter"

  ARTICLE = YAML.safe_load(<<~'YAML')
    slug: tenuta-vannulo-best-buffalo-mozzarella
    title: "In Search of Italy’s Best Mozzarella: A Pilgrimage to Tenuta Vannulo"
    published_at: 2026-11-24 00:00
    excerpt: There is mozzarella, and then there is mozzarella eaten an hour after it was made, on the farm where the buffalo live. A pilgrimage to Tenuta Vannulo, near Paestum.
    meta_title: "Tenuta Vannulo: Italy’s Best Buffalo Mozzarella, Paestum"
    meta_description: "A guide to buffalo mozzarella and Tenuta Vannulo, the organic family farm near Paestum: tastings, gelato, stable tours and a day out with the temples."
    hero_image: tenuta-vannulo-hero-buffalo-mozzarella.webp
    body: |
      <div><em>There is mozzarella, and then there is mozzarella eaten an hour after it was made, on the farm where the buffalo live.</em></div>
      <div>If you have only ever had mozzarella from a supermarket fridge, you have met a polite, slightly rubbery relative of the real thing. True buffalo mozzarella is something else: glossy, tender, and so fresh that when you cut it, milky whey spills across the plate. And for many Italians, and plenty of food critics, the best of it comes from one family farm on the plains near Paestum: Tenuta Vannulo.</div>
      <h2>First, a Quick Guide to Italian Mozzarella</h2>
      <div>Italy’s most prized mozzarella is <strong>Mozzarella di Bufala Campana DOP</strong>, made from the rich milk of water buffalo. The protected production area covers the whole provinces of Caserta and Salerno, plus parts of Naples, Benevento and a few areas in neighbouring regions.</div>
      <div>Within that area there are two great schools, and Italians argue about them happily:</div>
      <ul>
        <li><strong>Caserta</strong>, north of Naples, has the highest concentration of dairies and the oldest mozzarella traditions. Its mozzarella tends to be a little saltier and more assertive.</li>
        <li><strong>Salerno and Paestum</strong>, to the south, are known for a slightly milder, sweeter style.</li>
      </ul>
      <div>A few tips before you go hunting:</div>
      <ul>
        <li><strong>Freshness is everything.</strong> Mozzarella is at its best within a day or two of being made. Never refrigerate it if you’re eating it that day; keep it in its liquid at room temperature.</li>
        <li><strong>Look for the DOP logo</strong> on the packaging if you’re buying in a shop, so you know it is genuinely made with buffalo milk from the protected area.</li>
        <li><strong>Go to the source.</strong> The best experience is buying directly from a <em>caseificio</em> (dairy) in the morning, while the cheese is still warm.</li>
      </ul>
      <h2>Tenuta Vannulo: the Farm That Wrote Its Own Rules</h2>
      <div>Tenuta Vannulo sits a short drive from the Greek temples of Paestum, south of Salerno. It is run by the Palmieri family and was a pioneer in organic buffalo farming. Two things set it apart.</div>
      <div><strong>It uses only buffalo milk, and only its own.</strong> Many producers mix in cow’s milk or buy milk in. Vannulo makes its mozzarella exclusively from the milk of its own herd, and it sells it almost entirely on site. You won’t find it in shops; if you want it, you go to the farm. It is also famous for selling out, so the earlier you arrive, the better.</div>
      <div><strong>The buffalo live very well.</strong> Visitors are often charmed to see how the animals are treated: spacious stables, rotating brushes the buffalo use for a massage, and a milking system the animals walk into when they choose to. Happy buffalo, the family argues, make better milk.</div>
      <div>Critics agree. In a blind tasting by Italian food guide Gambero Rosso, Vannulo’s mozzarella came out top among the producers of the Salerno area.</div>
      <h2>What to Do There</h2>
      <div>A visit to Vannulo is more than a cheese run:</div>
      <ul>
        <li><strong>Taste the mozzarella</strong> in its classic round form or as a braided <em>treccia</em>, along with fresh ricotta.</li>
        <li><strong>Try the buffalo-milk yogurt, puddings and gelato.</strong> The gelato, made with buffalo milk, is a cult favourite in its own right.</li>
        <li><strong>Take a guided tour</strong> of the stables and the dairy, where you can watch the curd being stretched and shaped by hand.</li>
        <li><strong>Visit the small farm museum</strong> of rural life, and the workshop that makes leather goods from buffalo hide, so nothing goes to waste.</li>
      </ul>
      <div>Tours, opening hours and shop times vary by season, so check the farm’s website before you go and book a tour in advance in summer.</div>
      <h2>Make a Day of It</h2>
      <div>Pair Vannulo with the temples of Paestum, some of the best-preserved Greek temples anywhere, just a few minutes away. Start at the farm in the morning, when the tours run and the mozzarella is at its freshest, and stay for a mozzarella lunch with a glass of chilled local white wine such as Fiano or Falanghina. Then spend the afternoon wandering among the ruins as the light softens over the temples. It is hard to think of a better day in southern Italy.</div>
      <h2>Why It’s Worth the Trip</h2>
      <div>The best food is often the simplest, and buffalo mozzarella has nowhere to hide: it’s milk, salt, skill and time. At Vannulo you taste all four at their best, a short walk from the animals that made it possible. Once you’ve tried it there, the supermarket version will never quite feel the same.</div>
      <div>If you’re anywhere near Naples or the Amalfi Coast, make the detour. Bring an appetite, and arrive early.</div>
  YAML

  def up
    if Article.exists?(slug: ARTICLE["slug"])
      say "#{ARTICLE["slug"]}: already exists, skipped"
      return
    end

    article = Article.create!(
      **ARTICLE.slice("slug", "title", "excerpt", "meta_title", "meta_description", "body").symbolize_keys,
      published_at: Time.zone.parse(ARTICLE["published_at"].to_s),
      status: "published"
    )

    file = ARTICLE["hero_image"]
    article.hero_image.attach(io: Rails.root.join(IMAGE_DIR, file).open, filename: file, content_type: "image/webp")
    say "#{article.title}: added"
  end

  def down
    Article.find_by(slug: ARTICLE["slug"])&.destroy!
  end
end
