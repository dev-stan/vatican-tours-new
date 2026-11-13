# Adds the Caravaggio in Rome newsletter article. The content is frozen here so later edits elsewhere can't change what this
# migration does. If the post already exists it is left alone. The promoted tour is linked only if it exists in this
# database. Photos live in app/assets/images/newsletter. In the body, a line {{name}} becomes an inline photo: the
# image is uploaded as an Active Storage blob and embedded as an ActionText attachment with its caption.
class AddCaravaggioInRomeArticle < ActiveRecord::Migration[8.1]
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
    slug: caravaggio-in-rome
    title: "In the Footsteps of Caravaggio in Rome: Hidden Gems and Iconic Masterpieces"
    published_at: 2026-11-11 02:00
    excerpt: A painter of scandal, violence and genius. Follow Caravaggio through the churches, palaces and hidden ceilings of the Rome that shaped him.
    hero_image: caravaggio-hero-supper-at-emmaus.webp
    tour_image: borghese_gallery.webp
    tour: rome-baroque-walking-tour
    images:
      palafrenieri:
        file: caravaggio-01-madonna-of-the-palafrenieri.webp
        caption: Caravaggio, The Madonna of the Palafrenieri
      flight:
        file: caravaggio-02-rest-on-the-flight-into-egypt.webp
        caption: Caravaggio, Rest on the Flight into Egypt
      ludovisi:
        file: caravaggio-05-jupiter-neptune-and-pluto.webp
        caption: Caravaggio, Jupiter, Neptune and Pluto, on the ceiling of the Casino Ludovisi
    body: |
      <h2>Caravaggio: The Artist and the Rebel</h2>
      <div>Born in 1571 in Milan, Caravaggio moved to Rome as a young man to establish himself in the art world. His rise to fame was meteoric, but his life was marked by scandal, violence, and exile. Despite his tumultuous personal life, Caravaggio revolutionized the art of his time. His works were strikingly realistic, often depicting sacred figures with a raw humanity that shocked his contemporaries. His bold use of light and shadow, known as tenebrism, set a new standard in painting and influenced countless artists.</div>
      <div>Caravaggio’s time in Rome was prolific, and today, many of his masterpieces remain in the very churches and galleries where they were originally commissioned. Walking in his footsteps allows you to not only appreciate his genius but also glimpse the Rome of the late Renaissance — a city of power, faith, and dramatic contrasts.</div>
      <h2>Caravaggio Beyond the Famous Spots</h2>
      <div>Exploring Caravaggio’s Rome isn’t just about the art; it’s also about understanding the man behind it. His tumultuous life left traces across the city in unexpected places. While the well-known landmarks are essential, the hidden gems give a fuller picture of Caravaggio’s world.</div>
      <h3>1. Sant’Anna dei Palafrenieri: The Madonna of the Palafrenieri</h3>
      <div>Tucked within the Vatican Gardens, the Church of Sant’Anna dei Palafrenieri houses one of Caravaggio’s less celebrated works, <em>The Madonna of the Palafrenieri</em>. Originally intended for St. Peter’s Basilica, the painting was deemed too provocative and was moved here instead. It depicts the Virgin Mary teaching a young Christ to crush the serpent of sin, with Saint Anne, her mother, watching.</div>
      <div>This work stands out for its bold composition and the earthiness of its figures, reflecting Caravaggio’s unique approach to the divine. Visiting this site offers an opportunity to explore a quieter corner of the Vatican, far from the throngs of tourists.</div>
      {{palafrenieri}}
      <h3>2. Palazzo Doria Pamphilj: Rest on the Flight into Egypt</h3>
      <div>The Palazzo Doria Pamphilj is a private palace and gallery that feels like a time capsule of Rome’s aristocratic past. Here, you’ll find <em>Rest on the Flight into Egypt</em>, an early work of Caravaggio that demonstrates his softer, more lyrical side.</div>
      <div>The painting depicts the Holy Family pausing during their journey, accompanied by an angel playing the violin. Unlike his later, darker works, this piece is suffused with a gentle light, showcasing Caravaggio’s versatility. The gallery also houses works by other Baroque masters, offering a broader context for his influence.</div>
      {{flight}}
      <h3>3. Sant’Eustachio: A Local Legend</h3>
      <div>Though the Church of Sant’Eustachio doesn’t contain any confirmed works by Caravaggio, local legends suggest he frequented this area. Known for its vibrant coffee culture today, this neighborhood was once home to the rougher edges of Renaissance Rome, where Caravaggio found inspiration — and trouble.</div>
      <div>The church itself is worth visiting for its serene beauty and its proximity to some of Rome’s best coffee shops, such as the historic <em>Sant’Eustachio Il Caffè</em>. It’s a chance to pause and reflect, imagining Caravaggio walking these same streets.</div>
      <h3>4. Palazzo Madama: Echoes of the Past</h3>
      <div>Now the seat of the Italian Senate, Palazzo Madama was once a vibrant hub of aristocratic and artistic life. Caravaggio was known to have ties to the wealthy patrons who frequented the palace, and it’s said that his works were often discussed — and sometimes critiqued — within its walls.</div>
      <div>While you can’t enter the Senate without prior arrangements, simply standing outside this grand building and contemplating its history connects you to the artist’s world. Nearby Piazza Navona and Campo de’ Fiori were Caravaggio’s stomping grounds, full of taverns, gossip, and duels.</div>
      <h3>5. The Casino Ludovisi: Jupiter, Neptune, and Pluto</h3>
      <div>For a truly hidden gem, visit the Casino Ludovisi, a small villa that houses one of Caravaggio’s most unusual works: a ceiling painting of <em>Jupiter, Neptune, and Pluto</em>. Commissioned for Cardinal Del Monte, one of Caravaggio’s earliest patrons, this piece is strikingly different from his other works.</div>
      <div>Instead of his typical dramatic canvases, Caravaggio painted directly onto the ceiling of this private study. The figures of the three gods are rendered with astonishing realism, and Caravaggio even included a self-portrait as Pluto. The Casino Ludovisi is privately owned, so visits must be arranged in advance, but the effort is well worth it.</div>
      {{ludovisi}}
      <h2>The Spirit of Caravaggio’s Rome</h2>
      <div>Walking in Caravaggio’s footsteps isn’t just about admiring his masterpieces; it’s about immersing yourself in the vibrant, chaotic, and often dangerous world that shaped his art. From grand churches to quiet corners, from celebrated galleries to hidden ceilings, Rome offers countless opportunities to encounter Caravaggio’s genius and the city that inspired him.</div>
      <div>Whether you’re seeking out his most famous works or discovering the lesser-known sites that echo his presence, Caravaggio’s Rome is a city of contrasts — just like the artist himself. Take your time, wander the streets, and let the interplay of light and shadow guide you through this extraordinary journey.</div>
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
