# Adds the "Visiting the Vatican" Travel Advisor guide, with its hero photo of St. Peter's Square seen from the Dome. The content is frozen
# here so later edits elsewhere can't change what this migration does. If the guide already exists it is left alone. It
# promotes no tours. Photos live in app/assets/images/travel-tips.
class AddVisitingTheVaticanTravelTip < ActiveRecord::Migration[8.1]
  # The model as it was when this migration was written.
  class Guide < ActiveRecord::Base
    self.table_name = "travel_tips"
    def self.polymorphic_name = "TravelTip"

    has_rich_text :body
    has_one_attached :hero_image
  end

  IMAGE_DIR = "app/assets/images/travel-tips"

  GUIDE = YAML.safe_load(<<~'YAML')
    slug: visiting-the-vatican
    title: Visiting the Vatican
    published_at: 2026-11-25 00:00
    excerpt: So many choices, so little time! How to plan your Vatican visit, whether you have half a day, a full day or you've been before.
    meta_title: "Visiting the Vatican: How to Plan Your Time"
    meta_description: "Half a day, a full day or a return visit: how to choose between St. Peter's, the Vatican Museums, the Gardens and the Scavi, and when to book."
    hero_image: visiting-the-vatican-hero-st-peters-from-dome.webp
    body: |
      <div><strong>So many choices, so little time!</strong> If you are visiting Rome for the first time, the Vatican is almost certainly at the top of your list. But with so much to see, deciding how to spend your time can be a challenge.</div>
      <h2>What you can see</h2>
      <div>Although it is the smallest country in the world, Vatican City offers an extraordinary variety of experiences. Here are the main areas open to visitors:</div>
      <ul>
        <li><strong>St. Peter's Basilica</strong>: explore one of the world's most magnificent churches, discover the Papal Tombs beneath the Basilica and, if you wish, climb to the top of the Dome for spectacular views over Rome.</li>
        <li><strong>Vatican Museums and the Sistine Chapel</strong>: discover centuries of art and history, culminating in Michelangelo's unforgettable frescoes.</li>
        <li><strong>Vatican Gardens</strong>: enjoy a peaceful escape among beautifully landscaped gardens, fountains and historic monuments.</li>
        <li><strong>The Scavi – St. Peter's Tomb</strong>: descend beneath St. Peter's Basilica to explore the ancient Roman necropolis and the archaeological area traditionally associated with the tomb of St. Peter.</li>
      </ul>
      <h2>If you have just half a day</h2>
      <div>Short on time? We recommend a guided tour combining the Vatican Museums, the Sistine Chapel and St. Peter's Basilica. Allow approximately <strong>four hours</strong> for this experience.</div>
      <div>Consider an early-morning visit or a late-afternoon departure to make the most of your time and, where possible, avoid the busiest periods.</div>
      <div><strong>Our pick:</strong> Vatican City Essentials</div>
      <h2>If you have a full day</h2>
      <div>With a full day at your disposal, you can explore the Vatican at a more relaxed pace. In addition to the Museums and the Basilica, consider adding:</div>
      <ul>
        <li><strong>St. Peter's Dome</strong>: an ascent to the top, using the elevator for part of the climb.</li>
        <li><strong>The Vatican Gardens</strong>: a visit to the spectacular gardens, with their fountains, monuments and beautiful views.</li>
      </ul>
      <div>This combination offers a much more complete picture of Vatican City.</div>
      <div><strong>Our pick:</strong> All Day in Vatican</div>
      <h2>If you have visited the Vatican before</h2>
      <div>We have a special recommendation: the <strong>Scavi tour</strong>, the archaeological excavations beneath St. Peter's Basilica.</div>
      <div>This is one of the most fascinating and exclusive experiences in Rome. You will descend into the ancient necropolis, see the remains of the original burial ground and learn about the archaeological discoveries associated with St. Peter's tomb.</div>
      <div>Access is extremely limited, with approximately <strong>250 visitors admitted daily</strong>. Reservations must be requested well in advance and are subject to approval.</div>
      <div><strong>Our pick:</strong> Vatican Scavi and St. Peter's Tomb</div>
      <h2>Our most important advice: book early. Very early!</h2>
      <div>The Vatican is one of the most visited places in the world. Tickets for the Vatican Museums and the Sistine Chapel, particularly during the high season, can sell out weeks or even months in advance.</div>
      <div>If you have a particular date or time in mind, do not leave your reservation until the last minute.</div>
      <blockquote>And remember: the best Vatican visit is not necessarily the one that includes everything. It is the one that gives you enough time to appreciate what you are seeing.</blockquote>
  YAML

  def up
    if Guide.exists?(slug: GUIDE["slug"])
      say "#{GUIDE["slug"]}: already exists, skipped"
      return
    end

    guide = Guide.create!(
      **GUIDE.slice("slug", "title", "excerpt", "meta_title", "meta_description", "body").symbolize_keys,
      published_at: Time.zone.parse(GUIDE["published_at"].to_s),
      status: "published"
    )
    file = GUIDE["hero_image"]
    guide.hero_image.attach(io: Rails.root.join(IMAGE_DIR, file).open, filename: file, content_type: "image/webp")
    say "#{guide.title}: added"
  end

  def down
    Guide.find_by(slug: GUIDE["slug"])&.destroy!
  end
end
