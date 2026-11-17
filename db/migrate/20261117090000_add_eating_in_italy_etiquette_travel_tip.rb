# Adds the "Seven Things Not to Do When Eating in Italy" travel tips guide, with its hero photo and four inline photos.
# The content is frozen here so later edits elsewhere can't change what this migration does. If the guide already
# exists it is left alone. It promotes no tours. Photos live in app/assets/images/travel-tips. In the body, a line
# {{name}} becomes an inline photo: the image is uploaded as an Active Storage blob and embedded as an ActionText
# attachment with its caption.
class AddEatingInItalyEtiquetteTravelTip < ActiveRecord::Migration[8.1]
  # The model as it was when this migration was written.
  class Guide < ActiveRecord::Base
    self.table_name = "travel_tips"
    def self.polymorphic_name = "TravelTip"

    has_rich_text :body
    has_one_attached :hero_image
  end

  IMAGE_DIR = "app/assets/images/travel-tips"

  GUIDE = YAML.safe_load(<<~'YAML')
    slug: things-not-to-do-when-eating-in-italy
    title: Seven Things Not to Do When Eating in Italy
    published_at: 2026-11-17 00:00
    excerpt: From a late-night cappuccino to Parmesan on your clams, these are the dining mistakes that give visitors away in Italy, and what to do instead.
    meta_title: "Eating in Italy: 7 Food Etiquette Mistakes to Avoid"
    meta_description: "No cappuccino after breakfast, no cheese on seafood, no rushing: seven Italian dining rules every visitor should know before their trip."
    hero_image: eating-in-italy-hero-cafe.webp
    images:
      cappuccino:
        file: eating-in-italy-01-cappuccino.webp
        caption: In Italy, cappuccino belongs to the breakfast bar, not the dinner table
      seafood:
        file: eating-in-italy-02-seafood-pasta.webp
        caption: Seafood pasta is served without Parmesan, and nobody will offer you any
      regional:
        file: eating-in-italy-03-regional-food.webp
        caption: Every Italian region, and often every town, has dishes worth seeking out
      dinner:
        file: eating-in-italy-04-long-dinner.webp
        caption: An Italian meal is meant to be lingered over
    body: |
      <div>Italian food is everywhere, but Italian food culture travels much less well. In Italy, meals follow a set of unwritten rules that have little to do with snobbery and a lot to do with flavour: dishes are simple, built on seasonal and local ingredients, and eaten slowly. The rules exist to let those flavours shine.</div>
      <div>Break one and you may get a raised eyebrow. Follow them and you’ll eat better, and probably earn an approving nod from the table next to you. Here are seven things to avoid on your next trip.</div>
      <h2>1. Don’t order a cappuccino after breakfast</h2>
      <div>Visitors often ask what the cut-off time is for cappuccino. The easier rule: don’t order one in a restaurant at all. Cappuccino is a breakfast drink, taken standing at the coffee bar with a cornetto or pastry. Its milky richness is considered too heavy alongside a savoury lunch or dinner. Later in the day, Italians drink espresso or a macchiato.</div>
      {{cappuccino}}
      <h2>2. Don’t change the order of the meal</h2>
      <div>A traditional Italian meal moves from light to rich in a set sequence:</div>
      <ul>
        <li><strong>Antipasto</strong>: the starter</li>
        <li><strong>Primo</strong>: the pasta, risotto or soup course</li>
        <li><strong>Secondo e contorni</strong>: meat or fish, with vegetable sides on separate plates</li>
        <li><strong>Dolce</strong>: dessert</li>
        <li><strong>Caffè e amaro</strong>: espresso and a digestive</li>
      </ul>
      <div>You can skip courses, but you shouldn’t reorder them, and asking for everything to arrive at once is an unusual request. Salad isn’t a starter either: an <em>insalata mista</em>, dressed simply with olive oil, salt and lemon, is a side eaten with the main course. And pasta is never a side dish; it is a course of its own.</div>
      <h2>3. Don’t mix sea and mountain</h2>
      <div>Italian cooking tends to keep <em>mare</em> (the sea) and <em>monti</em> (the mountains, meaning meat and aged cheese) apart. The two traditions grew up separately, and their strong flavours are thought to compete. That’s why asking for Parmesan on <em>spaghetti alle vongole</em> makes Italians wince.</div>
      <div>The same logic applies across the meal: follow a seafood starter with a seafood pasta and fried calamari, rather than switching to a meat ragù halfway through. A few classic recipes do pair fish and cheese, such as pasta with mussels and pecorino, but these are deliberate exceptions.</div>
      {{seafood}}
      <h2>4. Don’t ask for substitutions</h2>
      <div>In Italy, a dish on the menu is the dish, not a starting point. Ingredients belong together for a reason, and so do pasta shapes and sauces: ridged short pasta catches chunky sauces, while long and filled pasta suits silkier ones. Asking the kitchen to swap an ingredient is seen as second-guessing the recipe and the chef.</div>
      <div>Allergies and dietary needs are a different matter. Mention them, and feel free to ask whether something like onion or garlic can be left out. Many cooks will gladly prepare something for you. What’s frowned upon is redesigning a dish to your taste.</div>
      <h2>5. Don’t ignore the local specialities</h2>
      <div>Italy was unified only in the second half of the 19th century, and many Italians still identify first with their region or hometown. Food is the same: there is no single “Italian cuisine”, but dozens of regional ones, each fiercely proud of its own dishes.</div>
      <div>Eat where you are. Have pizza in Naples, carbonara and cacio e pepe in Rome, pesto in Genoa, a <em>bistecca alla fiorentina</em> in Florence, limoncello on the Amalfi Coast and <em>cicchetti</em> with a spritz in a Venetian <em>bacaro</em>. Even small towns have a signature bread, cheese or dish, so ask what the place is known for before you order.</div>
      {{regional}}
      <h2>6. Don’t rush the meal</h2>
      <div>For Italians, eating out is a social occasion rather than a refuelling stop. Lunch or dinner can stretch over hours, with pauses between courses for conversation, another bottle of wine or a palate-cleansing lemon sorbet. Don’t expect the bill to arrive until you ask for it.</div>
      <div>Italians also eat later than many visitors: dinner often starts around 9 p.m., and a full meal can run close to midnight.</div>
      {{dinner}}
      <h2>7. Don’t skip the amaro</h2>
      <div>A proper Italian meal ends with dessert, an espresso and an amaro. The name means “bitter”: these herbal liqueurs, made with ingredients such as citrus peel, walnuts and medicinal herbs, are an acquired taste but a reliable cure for an overly generous dinner. Amari vary from region to region, so ask for the local one, or whether the house makes its own.</div>
      <h2>Quick recap</h2>
      <ul>
        <li>Cappuccino is for breakfast; order espresso after meals.</li>
        <li>Follow the order of courses; salad comes with the main.</li>
        <li>Keep seafood and cheese apart.</li>
        <li>Order dishes as they are, but always mention allergies.</li>
        <li>Eat the local specialities wherever you are.</li>
        <li>Take your time and eat later than you might at home.</li>
        <li>Finish with an espresso and an amaro.</li>
      </ul>
  YAML

  def up
    if Guide.exists?(slug: GUIDE["slug"])
      say "#{GUIDE["slug"]}: already exists, skipped"
      return
    end

    guide = Guide.create!(
      **GUIDE.slice("slug", "title", "excerpt", "meta_title", "meta_description").symbolize_keys,
      body: body_with_images,
      published_at: Time.zone.parse(GUIDE["published_at"].to_s),
      status: "published"
    )

    guide.hero_image.attach(image_upload(GUIDE["hero_image"]))
    say "#{guide.title}: added"
  end

  def down
    Guide.find_by(slug: GUIDE["slug"])&.destroy!
  end

  private

  # Swaps each {{name}} placeholder for an ActionText attachment of the uploaded photo.
  def body_with_images
    GUIDE["body"].gsub(/\{\{(\w+)\}\}/) do
      image = GUIDE["images"].fetch(Regexp.last_match(1))
      blob = ActiveStorage::Blob.create_and_upload!(**image_upload(image["file"]))
      %(<action-text-attachment sgid="#{blob.attachable_sgid}" content-type="image/webp" ) +
        %(filename="#{ERB::Util.h(image["file"])}" caption="#{ERB::Util.h(image["caption"])}"></action-text-attachment>)
    end
  end

  def image_upload(file)
    { io: Rails.root.join(IMAGE_DIR, file).open, filename: file, content_type: "image/webp" }
  end
end
