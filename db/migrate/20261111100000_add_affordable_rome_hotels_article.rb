# Adds the affordable Rome hotels newsletter article. The content is frozen here so later edits elsewhere can't change what
# this migration does. If the post already exists it is left alone. The promoted tour is linked only if it exists in
# this database. Photos live in app/assets/images/newsletter. In the body, a line {{name}} becomes an inline photo: the
# image is uploaded as an Active Storage blob and embedded as an ActionText attachment with its caption.
class AddAffordableRomeHotelsArticle < ActiveRecord::Migration[8.1]
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
    slug: best-affordable-hotels-in-rome
    title: 14 of the best affordable hotels in Rome under £150 according to ‘The Times’
    published_at: 2026-11-11 01:00
    excerpt: From small family-run hotels to newer, glossier options from cool brands, here are some of Rome’s very best affordable places to stay.
    hero_image: rome-hotels-hero.webp
    tour_image: colloseum.webp
    tour: rome-all-the-sights
    images:
      courtyard:
        file: rome-hotels-01-courtyard-central-park.webp
        caption: A balcony room at Courtyard Rome Central Park
      generator:
        file: rome-hotels-02-generator.webp
        caption: The bar at Generator Rome
      raffaello:
        file: rome-hotels-03-raffaello.webp
        caption: A room with a terrace at Hotel Raffaello
      trastevere:
        file: rome-hotels-04-trastevere.webp
        caption: A room at Hotel Trastevere
      aventino:
        file: rome-hotels-05-aventino.webp
        caption: Brocade and gilt at Hotel Aventino
      princeps:
        file: rome-hotels-06-princeps.webp
        caption: The palazzo housing Princeps Boutique Hotel
      lancelot:
        file: rome-hotels-07-lancelot.webp
        caption: A sitting room at Hotel Lancelot
      torre_argentina:
        file: rome-hotels-08-della-torre-argentina.webp
        caption: A rooftop terrace at Hotel Della Torre Argentina
      marisa:
        file: rome-hotels-09-marisa.webp
        caption: The breakfast room at Hotel Marisa
      le_petit:
        file: rome-hotels-10-le-petit.webp
        caption: The caryatids and columns of Hotel Le Petit
      modigliani:
        file: rome-hotels-11-modigliani.webp
        caption: Breakfast on a balcony at Hotel Modigliani
      holiday_inn:
        file: rome-hotels-12-holiday-inn.webp
        caption: The pool at Holiday Inn Rome — Eur Parco dei Medici
      torlonia:
        file: rome-hotels-13-principe-torlonia.webp
        caption: A room at Hotel Principe Torlonia
      milani:
        file: rome-hotels-14-milani.webp
        caption: A room at Hotel Milani
    body: |
      <div>With 28 centuries of history as a backdrop, you’d think that hotels here wouldn’t be able to live up to such impressiveness. Thankfully, that’s not the case. From small family-run hotels to newer, glossier options from cool brands, here are some of Rome’s very best affordable places to stay.</div>
      <h2>1. Courtyard Rome Central Park, Trionfale</h2>
      <div>Part of the Marriott megabrand, this four-star hotel compensates for its relatively far-flung location with the standard of service and facilities you’d expect at a major chain. You’ll find a fully equipped fitness centre and two restaurants — breakfast is at Pineto, while the Moscati bistro’s outdoor terrace is the spot for post-sightseeing sundowners. There’s a restrained palette in the bedrooms, some of which have balconies with views of Rome all the way to St Peter’s. It’s half an hour by public transport to the Vatican City cathedral, but the vast greenery of Pineto Regional Park is right on your doorstep.</div>
      {{courtyard}}
      <h2>2. Generator Rome, city centre</h2>
      <div>The Generator brand is known for its design-led social spaces, and its Rome outpost doesn’t let the side down. Guests can begin with a bargain buffet breakfast in the impeccably styled café, peppered with decorative tiles and pops of neon, and end with cocktails in a bar that falls somewhere between Chinese opium den and New York loft apartment. Set over seven floors, there’s also a summer-season rooftop terrace. The 77 rooms include dorms as well as keenly priced private doubles complete with en suite bathrooms, attracting a diverse, all-ages clientele and generating (pun intended) a warm and inclusive atmosphere.</div>
      {{generator}}
      <h2>3. Hotel Raffaello, city centre</h2>
      <div>This 41-room hotel close to Rome’s Termini station is part of Best Western’s Sure Hotel Collection. The look here is pretty traditional, with draped curtains in golden hues and a smattering of chandeliers, plus classically furnished bedrooms. There’s a pillow menu for maximum comfort, and family rooms that sleep up to four — the grown-up and kids’ quarters are partitioned. Set within the cobbled and ivy-strewn streets of the Monti district, it’s a ten-minute walk to the Colosseum, so well placed for a pitstop to revive tired children.</div>
      {{raffaello}}
      <h2>4. Hotel Trastevere, Trastevere</h2>
      <div>Trastevere (meaning “across the Tiber”) is one of Rome’s most picturesque neighbourhoods. A once working-class area resolutely on the up, its mostly car-free, maze-like lanes are now strewn with fashionable places to eat and drink. Keeping things old school is its namesake hotel, which prides itself on a traditional approach to hospitality. Guests rave about the friendly staff and the freshly baked pastries and blood orange juice served at breakfast. Rooms are comfortable, and the best overlook Piazza San Cosimato, known for its outdoor food market.</div>
      {{trastevere}}
      <h2>5. Hotel Aventino, city centre</h2>
      <div>This romantic small hotel provides the feel of an upmarket private residence. Guests arrive in a family portrait-filled lobby before being shown to one of 21 decadent bedrooms decked out with brocade fabrics and gilt mirrors. Some have balconies or Jacuzzi baths, but the most evocative is the secluded “tower room” with 360-degree views over Rome, including nearby Circus Maximus. In summer, breakfast is served in a courtyard garden, but various extras can be pre-booked year round — including shiatsu massages and personal trainer-led running tours.</div>
      {{aventino}}
      <h2>6. Princeps Boutique Hotel, city centre</h2>
      <div>This address has serious kerb appeal, occupying the upper floors of an aristocratic palazzo that looks like it might’ve been lifted from the Accidentally Wes Anderson Instagram account. Inside the look is calm and restrained, its palette of creams and greys offset by pops of plum and teal. With just 20 rooms, staff are able to be super-attentive to guests, happily offering tips on their favourite spots in the neighbouring Monti district, ten minutes away on foot. It’s directly opposite the Basilica of Santa Maria Maggiore, and many rooms have a view of the church.</div>
      {{princeps}}
      <h2>7. Hotel Lancelot, city centre</h2>
      <div>The Lancelot’s ivy-covered exterior feels like a gateway to another century, but it’s the old-fashioned approach to service that really makes this family-run property stand out. Guests love the warm and attentive staff, with everyone from manager to maid going above and beyond. The hotel hosts regular “round table” dinner events, while an all-day bar is open from morning espresso time to spritz o’clock. Rooms are simple, smattered with antique furnishings and Persian rugs, while private terraces on the upper floors offer Centro Storico views (it’s a stone’s throw from the Colosseum).</div>
      {{lancelot}}
      <h2>8. Hotel Della Torre Argentina, city centre</h2>
      <div>Only a five-minute walk from Piazza Navona and the Pantheon, this hotel is unbeatably central and rather lovely to boot. It’s spread across several floors of an 18th-century palace, and the look inside is classic — vaulted ceilings and exposed brickwork in the breakfast room, trompe l’oeil frescoes in reception, plus wooden flooring and furnishings. A lift will whisk you up to the hotel’s secret rooftop “Spritzeria”, where Aperol is served with a view along the historic Via dei Serpenti. The resident mixologist also provides cocktail-making courses, focusing on drinks invented in Rome.</div>
      {{torre_argentina}}
      <h2>9. Hotel Marisa, city centre</h2>
      <div>At this price it’s rare to find a place that you might want to photograph and add to your home renovations mood board, but this hotel near Termini station employs the less-is-more approach to great effect. Guests are greeted at a reception desk housed in an ornate nook akin to a secular altarpiece, while velvet chairs dot the corridors and rooms are rendered in mood-enhancing shades such as calming sage green and soothing grey. The breakfast room is an unexpected aesthetic highlight, with vintage travel posters sitting above mid-century-style seating.</div>
      {{marisa}}
      <h2>10. Hotel Le Petit, city centre</h2>
      <div>This hotel’s exterior is replete with architectural flourishes, but only its guests get to enjoy a morning cappuccino framed by its caryatids and columns. Inside it’s fifty shades of grey, from the marble-floored lobby to the feature walls, curtains and headboards in the bedrooms. It’s petit by name and nature, and the best of its 21 rooms have balconies — you can take your breakfast there, or make a beeline for the buffet. One minute from the Repubblica metro station, from here the rest of Rome is your oyster. Start with a short hop north to Villa Borghese, Rome’s most celebrated park.</div>
      {{le_petit}}
      <h2>11. Hotel Modigliani, city centre</h2>
      <div>This characterful hotel is named after the painter and sculptor beloved by its owners, and his works dot the lobby. Set at the top of an anonymous side-street, the Modigliani is remarkably peaceful given its central location — an eight-minute walk from the Spanish Steps. Guests are greeted with a free welcome drink and snacks, served in a flower-filled outdoor courtyard or the art deco-inspired lounge. The 23 guest rooms have been recently renovated, and there’s also a lovely two-bedroom apartment for families which can sleep up to six.</div>
      {{modigliani}}
      <h2>12. Holiday Inn Rome — Eur Parco dei Medici, Muratella</h2>
      <div>If you’ve got your heart set on a few laps before your flight home, consider booking one of the 316 spacious rooms at this resort near Fiumicino Airport. It’s set within rolling gardens and surrounded by sun loungers, and the sizable swimming pool will add much-needed R&amp;R to even the briefest Roman holiday. The sights downtown can be reached within half an hour by public transport or shuttle bus, but be sure to conserve enough energy to make use of the fitness centre, sauna and 27-hole golf course.</div>
      {{holiday_inn}}
      <h2>13. Hotel Principe Torlonia, Nomentano</h2>
      <div>This charming century-old property in the Nomentano neighbourhood used to count Mussolini among its neighbours — nearby Villa Torlonia was the Italian dictator’s official residence during the 1920s and 30s. Still grand and smattered with green, the area now benefits from a metro stop that will get you to the sights in ten minutes. The hotel’s pink and palatial exterior gives way to a chequered marble lobby and elegant, generously proportioned rooms, several of which have garden views. In fine weather, breakfast is served on a panoramic terrace, also an enticing spot for a sundowner.</div>
      {{torlonia}}
      <h2>14. Hotel Milani, city centre</h2>
      <div>Channelling the high style of Italy’s fashion capital Milan, this boutique hotel looks much more expensive than it is. Guests arrive in a chic lobby with fireplace, landscape paintings and art deco-style chandelier, while rooms are painted in pared-back ice cream shades. After a disco nap on premium linens, swing by Milani’s on-site bar before heading on to nearby Santa Maria Maggiore, home to some of the city’s best cut-price drinking holes. Close to Termini station, the property is a half-hour walk from the Roman Forum.</div>
      {{milani}}
      <div><em>Source: <a href="https://www.thetimes.com/travel/destinations/europe-travel/italy/rome/best-affordable-hotels-in-rome-kdb2kcttd">The Times</a>, 3 September 2024</em></div>
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
