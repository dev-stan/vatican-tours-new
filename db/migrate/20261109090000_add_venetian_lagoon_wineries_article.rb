# Adds the first newsletter article to databases that already exist, without re-running the seeds. The content is frozen
# here rather than read from db/seeds/newsletter_articles.yml, so later edits to that file can't change what this migration
# does. If the post already exists (e.g. it was seeded), it is left alone. The promoted tour is linked only if it
# exists in this database.
class AddVenetianLagoonWineriesArticle < ActiveRecord::Migration[8.1]
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

  ARTICLE = YAML.safe_load(<<~'YAML')
    slug: venetian-lagoon-wineries
    title: The Wineries of the Venetian Lagoon
    published_at: 2026-11-07 09:00
    excerpt: Golden Dorona grapes behind medieval walls, vines rooted in salty sand, and a glass of wine poured a short walk from where it grew.
    hero_image: burano.webp
    tour_image: venice-vinery.webp
    tour: venice-lagoon-and-winery
    body: |
      <div>Most visitors to Venice never think of it as wine country. Yet for centuries the islands of the lagoon fed the city: vegetables from the market gardens, fish from the shallows, and wine from vineyards planted by monasteries and noble families for their own tables. Floods, plague and the pull of the mainland emptied most of those vineyards long ago, but a handful of growers have brought the vines back, and the wine they make tastes like nowhere else in Italy.</div>
      <h2>The golden grape of the Republic</h2>
      <div>The story most people hear is of Dorona, a golden grape once poured at the tables of the Venetian Republic. It nearly disappeared, until a few old vines were found surviving in island gardens and replanted inside a walled vineyard on Mazzorbo, the quiet island joined to Burano by a wooden bridge. The vines grow beside a medieval bell tower, and the grapes ripen in sea air and sandy soil. The wine is amber, a little salty, and made in tiny quantities.</div>
      <h2>Vines in salty sand</h2>
      <div>Growing grapes in the lagoon is not easy. The soil is sandy and full of salt, the water table sits just under the roots, and the highest tides can flood the rows. Growers here work by hand and by boat, and every harvest is carried across the water. That struggle is part of what you taste: lagoon whites are bright, mineral and saline, perfect with the <em>cicchetti</em> and seafood of Venetian bàcari.</div>
      <h2>Why a visit is worth it</h2>
      <div>A morning among the lagoon vineyards shows a different Venice: salt marshes instead of crowds, birds instead of selfie sticks, and winemakers who can tell you which island every bottle came from. Pair it with the painted houses of Burano and a slow boat ride back past the abandoned islands of the northern lagoon, and you have one of the most memorable days you can spend in Venice.</div>
  YAML

  def up
    if Article.exists?(slug: ARTICLE["slug"])
      say "#{ARTICLE["slug"]}: already exists, skipped"
      return
    end

    tour = Tour.find_by(slug: ARTICLE["tour"])
    say "#{ARTICLE["tour"]}: tour not found, article saved without a promoted tour" unless tour

    article = Article.create!(
      **ARTICLE.slice("slug", "title", "excerpt", "body").symbolize_keys,
      published_at: Time.zone.parse(ARTICLE["published_at"].to_s),
      tour:,
      status: "published"
    )

    %w[hero_image tour_image].each do |name|
      file = ARTICLE[name]
      article.public_send(name).attach(io: Rails.root.join("app/assets/images/tours", file).open, filename: file,
                                       content_type: "image/webp")
    end
    say "#{article.title}: added"
  end

  def down
    Article.find_by(slug: ARTICLE["slug"])&.destroy!
  end
end
