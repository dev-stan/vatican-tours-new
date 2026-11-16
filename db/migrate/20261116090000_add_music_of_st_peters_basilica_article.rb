# Adds "The Music of St Peter's Basilica: Palestrina, Benevoli and Corelli" newsletter article. The content is frozen
# here so later edits elsewhere can't change what this migration does. If the post already exists it is left alone.
# The promoted tour is linked only if it exists in this database. Photos live in app/assets/images/newsletter. In the
# body, a line {{name}} becomes an inline photo: the image is uploaded as an Active Storage blob and embedded as an
# ActionText attachment with its caption.
class AddMusicOfStPetersBasilicaArticle < ActiveRecord::Migration[8.1]
  # The model as it was when this migration was written.
  class Article < ActiveRecord::Base
    self.table_name = "newsletter_articles"
    def self.polymorphic_name = "NewsletterArticle"

    belongs_to :tour, optional: true
    has_rich_text :body
    has_one_attached :hero_image
    has_one_attached :tour_image
  end

  IMAGE_DIR = "app/assets/images/newsletter"

  ARTICLE = YAML.safe_load(<<~'YAML')
    slug: music-of-st-peters-basilica
    title: "The Music of St Peter’s Basilica: Palestrina, Benevoli and Corelli"
    published_at: 2026-11-16 00:00
    excerpt: Discover the musical heritage of the Vatican through three great composers who shaped the sound of Renaissance and Baroque Rome.
    meta_title: "The Music of St Peter’s: Palestrina, Benevoli & Corelli"
    meta_description: "The Cappella Giulia, Palestrina’s polyphony, Benevoli’s multiple choirs and Corelli’s Christmas Concerto: the musical history of St Peter’s Basilica."
    hero_image: st-peters-music-hero-baldachin-liturgy.webp
    tour_image: st-peters-basilica-inside.webp
    tour: highlights-st-peters-basilica-dome-papal-tombs
    images:
      choirs:
        file: st-peters-music-01-multiple-choirs.webp
        caption: Multiple choirs and instrumental groups in performance
      manuscript:
        file: st-peters-music-02-choirbook-manuscript.webp
        caption: A seventeenth-century music manuscript
      corelli:
        file: st-peters-music-03-arcangelo-corelli.webp
        caption: Arcangelo Corelli
      cancelleria:
        file: st-peters-music-04-palazzo-della-cancelleria.webp
        caption: The courtyard of the Palazzo della Cancelleria, Cardinal Ottoboni’s Roman residence
      score:
        file: st-peters-music-05-christmas-concerto-score.webp
        caption: Corelli, Concerto VIII, “Fatto per la notte di Natale”
    body: |
      <div>St Peter’s Basilica is one of the greatest artistic and architectural achievements in the world. Millions of visitors come to admire Michelangelo’s Pietà, Bernini’s magnificent Baldachin and the extraordinary dome designed by Michelangelo. Yet there is another dimension to the history of this remarkable place that is often overlooked: its music.</div>
      <div>For centuries, music has played an essential role in the religious and ceremonial life of the Vatican. From the solemn chants of the Renaissance to the spectacular polyphonic compositions of the Baroque period, the musical tradition of St Peter’s reflects the artistic ambitions, spiritual aspirations and cultural influence of the papacy.</div>
      <div>Three composers help tell this story: Giovanni Pierluigi da Palestrina, Orazio Benevoli and Arcangelo Corelli. Although their careers were different, all three were part of the extraordinary musical world that made Rome one of Europe’s most important centres of music.</div>
      <h2>Three Great Composers – Three Musical Worlds</h2>
      <div>Each of these recordings brings one of our three composers to life – together they span almost two centuries of Roman music.</div>
      <ul>
        <li><strong>Palestrina – <em>Missa Papae Marcelli</em></strong>: Renaissance sacred polyphony. Sistine Chapel Choir, Massimo Palombella (Deutsche Grammophon).</li>
        <li><strong>Benevoli – <em>Missa Tu es Petrus</em></strong>: monumental polychoral music. I Fagiolini, The City Musick, Robert Hollingworth (CORO).</li>
        <li><strong>Corelli – Christmas Concerto, Op. 6 No. 8</strong>: Baroque instrumental music. American Bach Soloists, Jeffrey Thomas.</li>
      </ul>
      <h2>The Cappella Giulia: The Musical Heart of St Peter’s</h2>
      <div>To understand the musical history of St Peter’s, we must begin with the Cappella Giulia, the choir established in 1513 by Pope Julius II.</div>
      <div>Its principal responsibility was to provide music for the daily liturgical services in St Peter’s Basilica, as well as important religious celebrations. It was a distinct institution from the famous Cappella Sistina, the Pope’s personal choir, which performed during papal liturgies.</div>
      <div>The Cappella Giulia became an important centre of sacred music, employing professional singers and working with some of the greatest composers of the Renaissance and Baroque periods. Among its most distinguished musical directors were Palestrina and Benevoli.</div>
      <div>Their music transformed the experience of religious ceremonies, demonstrating how sound could become an essential part of the architectural and spiritual character of St Peter’s.</div>
      <h2>Giovanni Pierluigi da Palestrina</h2>
      <div><em>c. 1525–1594 · The Master of Renaissance Sacred Music</em></div>
      <div>Palestrina is perhaps the most celebrated composer associated with the musical history of St Peter’s Basilica.</div>
      <div>Born in the town of Palestrina, near Rome, Giovanni Pierluigi moved to the Eternal City as a young musician. In 1551, Pope Julius III appointed him to the Cappella Giulia at St Peter’s, where he served as a teacher and musical director. He was only about 26 years old.</div>
      <div>His career subsequently took him to other important Roman churches, including St John Lateran and Santa Maria Maggiore. In 1571, however, he returned to St Peter’s, where he remained associated with the Cappella Giulia until his death in 1594.</div>
      <h3>Music and the Council of Trent</h3>
      <div>Palestrina lived during one of the most important periods in the history of the Catholic Church. The Council of Trent (1545–1563), held during the Catholic Reformation, addressed many aspects of religious practice, including the role of music in the liturgy.</div>
      <div>Some churchmen were concerned that elaborate polyphonic compositions could make religious texts difficult to understand. There was a desire to ensure that sacred music retained its spiritual character while allowing the words of the liturgy to remain intelligible.</div>
      <div>Palestrina became closely associated with the ideal of clear, balanced and beautifully structured sacred polyphony. His famous <em>Missa Papae Marcelli</em> is traditionally connected with the story that he helped save polyphonic music from prohibition. Although the story is not supported by firm historical evidence, it illustrates his lasting reputation as a master of sacred composition.</div>
      <h3>His final years at St Peter’s</h3>
      <div>Palestrina died in Rome on 2 February 1594. His funeral was celebrated at St Peter’s Basilica, where he was also buried. Although his original tomb has not survived in a clearly identifiable form, his musical legacy remains deeply connected with the Basilica.</div>
      <blockquote><strong>Recommended listening:</strong> <em>Missa Papae Marcelli</em>, particularly the Kyrie and Gloria – sung by the Sistine Chapel Choir under Massimo Palombella (Deutsche Grammophon).</blockquote>
      <h2>Orazio Benevoli</h2>
      <div><em>1605–1672 · The Spectacular Sound of Baroque St Peter’s</em></div>
      <div>More than a generation after Palestrina’s death, another Roman composer became one of the most important figures in the musical life of St Peter’s.</div>
      <div>Orazio Benevoli was born in Rome in 1605. In 1646, he was appointed Maestro di Cappella of the Cappella Giulia, a position he held until his death in 1672.</div>
      <div>If Palestrina represents the refined vocal polyphony of the Renaissance, Benevoli represents the grandeur and dramatic possibilities of Baroque sacred music.</div>
      <h3>The extraordinary technique of multiple choirs</h3>
      {{choirs}}
      <div>Benevoli became particularly famous for his use of <em>policoralità</em>, or polychoral composition.</div>
      <div>Instead of writing for one choir singing together, he composed music for several independent choirs, which could be positioned in different parts of a church. The groups could sing in alternation, answer one another and eventually combine in powerful musical passages.</div>
      <div>Imagine standing inside St Peter’s during a solemn seventeenth-century celebration. Voices coming from different directions would have filled the enormous interior, creating an extraordinary experience of sound and space.</div>
      <div>This approach was particularly suited to the monumental architecture of Baroque Rome, where music, sculpture, painting and architecture combined to create an impressive religious experience.</div>
      <div>One of Benevoli’s remarkable achievements was a twelve-choir Mass performed at Santa Maria sopra Minerva in Rome in 1650, involving approximately 150 musicians.</div>
      {{manuscript}}
      <blockquote><strong>Recommended listening:</strong> <em>Missa Tu es Petrus</em> – written for four choirs and based on Palestrina’s famous motet <em>Tu es Petrus</em>, it was probably intended for the newly completed St Peter’s: a beautiful musical bridge between our first two composers. Recorded for the first time by I Fagiolini and The City Musick under Robert Hollingworth (CORO).</blockquote>
      <h2>Arcangelo Corelli</h2>
      <div><em>1653–1713 · The Musical Brilliance of Baroque Rome</em></div>
      {{corelli}}
      <div>While Palestrina and Benevoli were directly connected with the musical institution of St Peter’s, Arcangelo Corelli represents another important aspect of the Vatican’s cultural environment: the extraordinary musical life of Baroque Rome.</div>
      <div>Born in Fusignano in northern Italy in 1653, Corelli arrived in Rome during the 1670s and became one of Europe’s most celebrated violinists and composers.</div>
      <div>Unlike Palestrina and Benevoli, Corelli was not a director of the Cappella Giulia. His career developed primarily through the patronage of wealthy and influential members of Roman aristocracy and the Church. Among his most important patrons were Queen Christina of Sweden, Cardinal Benedetto Pamphili and Cardinal Pietro Ottoboni.</div>
      <h3>Cardinal Ottoboni and the musical world of the Vatican</h3>
      {{cancelleria}}
      <div>Cardinal Pietro Ottoboni was particularly important in Corelli’s career. A grand-nephew of Pope Alexander VIII, he was one of the leading patrons of art and music in Rome.</div>
      <div>His palace became an important centre of musical activity, hosting concerts and performances attended by members of the Roman aristocracy. Corelli performed there, directed musical events and helped establish Rome as one of Europe’s leading centres of instrumental music.</div>
      <div>His compositions were influential throughout Europe, particularly his violin sonatas and concerti grossi, in which a small group of solo instruments contrasts with a larger ensemble.</div>
      <div>Although Corelli did not hold an official position at St Peter’s, his career illustrates the close relationship between music, the Church and the powerful cardinals who shaped the cultural life of Baroque Rome.</div>
      <h3>The Christmas Concerto</h3>
      {{score}}
      <div>One of Corelli’s most beautiful compositions is his Concerto Grosso in G minor, Op. 6 No. 8, commonly known as the Christmas Concerto. Its full title includes the words <em>Fatto per la notte di Natale</em> – composed for Christmas Eve.</div>
      <div>The final movement, known as the Pastorale, evokes the peaceful atmosphere traditionally associated with the Nativity. It is one of the most celebrated examples of Baroque Christmas music and a beautiful reminder of the musical culture that flourished in Rome during the age of Bernini.</div>
      <blockquote><strong>Recommended listening:</strong> Corelli’s Christmas Concerto, Op. 6 No. 8, especially the final Pastorale – performed by the American Bach Soloists under Jeffrey Thomas.</blockquote>
      <h2>Three Composers, Three Musical Worlds</h2>
      <div>The careers of these three composers illustrate the evolution of music in Rome over almost two centuries.</div>
      <ul>
        <li><strong>Palestrina</strong> – Renaissance vocal polyphony. Director of the Cappella Giulia. Start listening with <em>Missa Papae Marcelli</em>.</li>
        <li><strong>Benevoli</strong> – monumental polychoral sacred music. Director of the Cappella Giulia. Start listening with <em>Missa Tu es Petrus</em>.</li>
        <li><strong>Corelli</strong> – Baroque violin and orchestral music. Patronage of Roman cardinals. Start listening with the Christmas Concerto, Op. 6 No. 8.</li>
      </ul>
      <div>Palestrina represents the Renaissance ideal of balanced vocal polyphony, in which several voices combine with extraordinary precision and clarity.</div>
      <div>Benevoli expanded the possibilities of sacred music, using multiple choirs to create spectacular musical effects within the great churches of Rome.</div>
      <div>Corelli, meanwhile, helped establish Rome as one of Europe’s leading centres of instrumental music, supported by the patronage of powerful cardinals and aristocratic families.</div>
      <div>Their careers were different, but all three belonged to a city where music was an essential part of religious, artistic and social life.</div>
      <h2>The Musical Heritage of St Peter’s Today</h2>
      <div>The musical tradition of St Peter’s Basilica has never disappeared.</div>
      <div>The Cappella Giulia continues to provide music for liturgical celebrations in the Basilica, preserving a tradition that began more than five centuries ago. Its repertoire includes Gregorian chant, Renaissance polyphony and compositions from later periods.</div>
      <div>For visitors, understanding this musical heritage adds another dimension to the experience of St Peter’s. Beyond Michelangelo’s Pietà, Bernini’s Baldachin and the magnificent dome, there is a history of music that helped shape the spiritual and artistic identity of the Vatican.</div>
      <div>The next time you enter St Peter’s Basilica, imagine the voices of Palestrina’s singers, the multiple choirs of Benevoli and the instrumental brilliance of Corelli’s Baroque Rome.</div>
      <div><strong>You may discover that the history of St Peter’s is not only something to see. It is also something to hear.</strong></div>
  YAML

  def up
    if Article.exists?(slug: ARTICLE["slug"])
      say "#{ARTICLE["slug"]}: already exists, skipped"
      return
    end

    tour = Tour.find_by(slug: ARTICLE["tour"])
    say "#{ARTICLE["tour"]}: tour not found, article saved without a promoted tour" unless tour

    article = Article.create!(
      **ARTICLE.slice("slug", "title", "excerpt", "meta_title", "meta_description").symbolize_keys,
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
