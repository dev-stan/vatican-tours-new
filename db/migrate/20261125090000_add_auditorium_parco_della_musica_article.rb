# Adds the "Renzo Piano's Auditorium in Rome — and the Sound of Santa Cecilia" newsletter article: the architect, the
# Auditorium Parco della Musica, the history of the Orchestra di Santa Cecilia and highlights of its 2027 season. The
# content is frozen here so later edits elsewhere can't change what this migration does. If the post already exists it
# is left alone. Instead of a tour, the article promotes our concierge service through the contact page. Photos live in
# app/assets/images/newsletter. In the body, a line {{name}} becomes an inline photo: the image is uploaded as an Active
# Storage blob and embedded as an ActionText attachment with its caption.
class AddAuditoriumParcoDellaMusicaArticle < ActiveRecord::Migration[8.1]
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
    slug: renzo-piano-auditorium-rome-santa-cecilia
    title: "Renzo Piano’s Auditorium in Rome — and the Sound of Santa Cecilia"
    published_at: 2026-11-24 00:00
    excerpt: Architecture, music and a 2027 season worth planning a trip around. Inside Renzo Piano’s Auditorium Parco della Musica, home of the Orchestra di Santa Cecilia.
    meta_title: "Renzo Piano’s Auditorium, Rome: Santa Cecilia’s 2027 Season"
    meta_description: "Renzo Piano’s Auditorium Parco della Musica in Rome, the history of the Orchestra di Santa Cecilia and the highlights of its 2027 Beethoven season."
    hero_image: auditorium-rome-hero-halls-and-cavea.webp
    promo_image: auditorium-rome-04-cavea-summer-concert.webp
    promo_url: /contact
    promo_title: Travel With Us
    promo_text: |
      Leave the planning to us. We book your concert, opera and theatre tickets, reserve a table before or after the show and arrange your transfer to the Auditorium.

      All you have to do is take your seat and enjoy the music.
    promo_button: Check our concierge service
    images:
      piano:
        file: auditorium-rome-01-renzo-piano.webp
        caption: Renzo Piano in his workshop, surrounded by models and prototypes
      sala:
        file: auditorium-rome-02-sala-santa-cecilia.webp
        caption: The Sala Santa Cecilia, the largest of the three halls, under its curved cherry-wood ceiling
      recital:
        file: auditorium-rome-03-piano-recital.webp
        caption: A full house in the Sala Santa Cecilia for a piano recital
      cavea:
        file: auditorium-rome-04-cavea-summer-concert.webp
        caption: A summer evening concert in the open-air Cavea
      orchestra:
        file: auditorium-rome-05-santa-cecilia-orchestra.webp
        caption: The Orchestra dell’Accademia Nazionale di Santa Cecilia on its home stage
      pappano:
        file: auditorium-rome-06-antonio-pappano.webp
        caption: Sir Antonio Pappano, music director from 2005 to 2023
      harding:
        file: auditorium-rome-07-daniel-harding.webp
        caption: Daniel Harding, music director since 2024, in the Sala Santa Cecilia
    body: |
      <div><em>Architecture, music and a 2027 season worth planning a trip around.</em></div>
      <div>North of Rome’s historic centre, between the Parioli hills and the Olympic Village, three giant lead-grey shells rise out of a park like enormous beetles – or, as their architect prefers, like the soundboxes of musical instruments. This is the <strong>Auditorium Parco della Musica Ennio Morricone</strong>, the work of Renzo Piano and one of the most visited cultural venues in Europe.</div>
      <h2>Renzo Piano: the Architect</h2>
      {{piano}}
      <div>Born in Genoa in 1937 into a family of builders, Renzo Piano became famous almost overnight when, with Richard Rogers, he won the competition for the Centre Pompidou in Paris. Since then his Renzo Piano Building Workshop, with studios in Genoa, Paris and New York, has built on every continent. He received the Pritzker Prize – architecture’s highest honour – in 1998, and in 2013 he was appointed a Senator for Life of the Italian Republic.</div>
      <div>Piano’s buildings share a recognisable DNA: lightness, natural light, visible craftsmanship and a deep respect for context. He once said that the most intriguing adventure for an architect is to build a concert hall – and in Rome he built three.</div>
      <h2>The Auditorium Parco della Musica</h2>
      {{sala}}
      <div>In 1994 the City of Rome held an international competition for a new music complex to give the Accademia Nazionale di Santa Cecilia a permanent home. Renzo Piano won it, and the project officially began in January 1995. During excavation, workers uncovered the remains of an ancient Roman villa; Piano reshaped his design around them and added a small archaeological museum – a decision that delayed completion by a year. The Auditorium opened on 21 December 2002, and in 2020, after the death of the great film composer, it was renamed in honour of <strong>Ennio Morricone</strong>.</div>
      <div>The complex is built around three halls of different sizes, each tuned for a different kind of music, with acoustics designed by Jürgen Reinhold of Müller-BBM:</div>
      <ul>
        <li><strong>Sala Santa Cecilia</strong> (about 2,800 seats) – the largest hall, home of the Santa Cecilia orchestra’s symphonic season, with the audience seated in “vineyard” terraces around the stage</li>
        <li><strong>Sala Sinopoli</strong> (about 1,200 seats) – chamber music, smaller symphonic programmes, dance and contemporary music</li>
        <li><strong>Sala Petrassi</strong> (about 700 seats) – a flexible hall for theatre, chamber concerts, film and talks</li>
        <li><strong>The Cavea</strong> – the open-air amphitheatre between the three halls, the heart of the summer concerts</li>
      </ul>
      <div>The landscaped park by Franco Zagari wraps around the halls, and a curved foyer connects them, lit by a permanent neon installation by Tuscan artist Maurizio Nannucci.</div>
      <h3>How the Auditorium Is Used</h3>
      {{recital}}
      {{cavea}}
      <div>Run by the Fondazione Musica per Roma, the Auditorium is less a concert hall than a cultural campus – Romans call it a “factory of culture”. Its main resident is the Orchestra and Chorus of Santa Cecilia, but the same halls host jazz, pop and world-music tours, theatre and dance, festivals of books and science and, every autumn, the Rome Film Fest. In summer the open-air Cavea becomes one of the city’s favourite concert stages, while the foyers hold exhibitions next to the small archaeological museum. Even without a ticket, the park, bookshop and café make it a pleasant stop.</div>
      <h2>A Short History of the Orchestra di Santa Cecilia</h2>
      {{orchestra}}
      <div>The Accademia Nazionale di Santa Cecilia is one of the oldest musical institutions in the world. Its roots go back to the second half of the 1500s, when a group of chapel masters and choristers formed an association and elected <strong>Giovanni Pierluigi da Palestrina</strong> as their president.</div>
      <div>The orchestra came much later. Founded in <strong>1908</strong>, it was the first Italian orchestra devoted entirely to the symphonic repertoire rather than opera. Its first home was the <strong>Augusteo</strong>, a hall built on top of the Mausoleum of Emperor Augustus, where it played until 1936. In its early decades it gave the premieres of Respighi’s <em>Fountains of Rome</em> and <em>Pines of Rome</em>, and was conducted by composers such as Mahler, Debussy, Richard Strauss and Stravinsky, as well as Toscanini, Furtwängler, Karajan and Carlos Kleiber.</div>
      <div>In the mid-20th century the orchestra made celebrated opera recordings with Tullio Serafin and singers like Renata Tebaldi. <strong>Leonard Bernstein</strong> was its honorary president from 1983 until 1990, while <strong>Giuseppe Sinopoli</strong> broadened its repertoire to Mahler and Bruckner. In 2002 the orchestra finally moved into Renzo Piano’s purpose-built Sala Santa Cecilia.</div>
      {{pappano}}
      <div>Under <strong>Sir Antonio Pappano</strong>, music director from 2005 to 2023, Santa Cecilia built a major international reputation through award-winning recordings and tours to the BBC Proms, Salzburg, Lucerne, New York and Tokyo. Since 2024 the orchestra has been led by British conductor <strong>Daniel Harding</strong>.</div>
      {{harding}}
      <div>Born in Oxford in 1975, Harding was a prodigy: at 17 he sent a tape of his conducting to Simon Rattle, who made him his assistant in Birmingham, and he later assisted Claudio Abbado. He went on to lead the Swedish Radio Symphony Orchestra from 2007 and the Orchestre de Paris from 2016 to 2019, and is a regular guest of the Vienna and Berlin Philharmonics. In Rome he has brought staged Wagner into the Sala Santa Cecilia – <em>Die Walküre</em> in 2025, <em>Siegfried</em> in 2026 – and is working through a complete, chronological Mahler cycle. Away from the podium he is a qualified airline pilot, and from the 2027–28 season he will also become music director of the Los Angeles Philharmonic.</div>
      <h2>Highlights of the 2027 Season</h2>
      <div>The 2026/27 season runs from October 2026 to June 2027. Its 2027 programme is built around a clear theme: <strong>the 200th anniversary of Beethoven’s death</strong> (he died in March 1827), with many of his greatest works scheduled across the year. Alongside it come Daniel Harding’s ongoing Mahler cycle, new commissions and a parade of star soloists. Our picks for January–June 2027:</div>
      <h3>The Beethoven Bicentenary</h3>
      <ul>
        <li><strong>7–9 January</strong> – Riccardo Minasi opens the year with the <em>Eroica</em> Symphony and rarely heard choral works</li>
        <li><strong>11–13 February</strong> – Antonio Pappano returns to his former orchestra with Jan Lisiecki in the <em>Emperor</em> Concerto, paired with Shostakovich’s Eighth Symphony</li>
        <li><strong>25–27 February</strong> – Fabio Luisi conducts the monumental <em>Missa Solemnis</em></li>
        <li><strong>18–20 March</strong> – Charles Dutoit and the legendary <strong>Martha Argerich</strong> in Beethoven’s First Piano Concerto, with Dvořák’s <em>New World</em> Symphony</li>
        <li><strong>22–24 April</strong> – Daniel Harding conducts <strong>Beethoven’s Ninth Symphony</strong>, preceded by the world premiere of Stefano Gervasoni’s <em>Rischiare la gioia</em>, a commission from the Accademia</li>
      </ul>
      <h3>Daniel Harding’s Spring</h3>
      <ul>
        <li><strong>4–6 March</strong> – Beatrice Rana plays Prokofiev’s Third Piano Concerto; Sibelius’s Second Symphony</li>
        <li><strong>8–10 April</strong> – A French programme: Debussy’s <em>La Mer</em> and Ravel’s <em>Daphnis et Chloé</em></li>
        <li><strong>15–17 April</strong> and <strong>20–22 May</strong> – Mahler’s Fifth and Sixth Symphonies</li>
        <li><strong>13–17 May</strong> – Leoncavallo’s <em>Pagliacci</em> in concert, with tenor Brian Jagde as Canio</li>
      </ul>
      <h3>Star Soloists and Guest Conductors</h3>
      <ul>
        <li><strong>28–30 January</strong> – Daniil Trifonov with Jakub Hrůša</li>
        <li><strong>18–20 February</strong> – Lisa Batiashvili with Lorenzo Viotti, plus Stravinsky’s <em>The Rite of Spring</em></li>
        <li><strong>29 April – 2 May</strong> – Rudolf Buchbinder plays and conducts three Mozart piano concertos</li>
        <li><strong>6–8 May</strong> – Katia and Marielle Labèque with Semyon Bychkov</li>
      </ul>
      <h3>The Finale</h3>
      <ul>
        <li><strong>3–5 June</strong> – <strong>Joe Hisaishi</strong> conducts his own music, including a symphonic suite from the Studio Ghibli films of Hayao Miyazaki – a closing night sure to sell out fast</li>
      </ul>
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

    article.hero_image.attach(image_upload(ARTICLE["hero_image"]))
    article.promo_image.attach(image_upload(ARTICLE["promo_image"]))
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
