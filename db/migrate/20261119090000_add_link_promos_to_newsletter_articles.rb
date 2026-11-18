# The box under a newsletter article could only advertise a tour. It can now promote any page instead: one of ours
# (e.g. /?region=tuscany) or another site's, with its own heading, text and button. Its photo is no longer always a
# tour's, so the tour_image attachment becomes promo_image.
class AddLinkPromosToNewsletterArticles < ActiveRecord::Migration[8.1]
  def change
    change_table :newsletter_articles, bulk: true do |t|
      t.string :promo_url
      t.string :promo_title
      t.text :promo_text
      t.string :promo_button
    end

    reversible do |dir|
      dir.up { rename_attachment from: "tour_image", to: "promo_image" }
      dir.down { rename_attachment from: "promo_image", to: "tour_image" }
    end
  end

  private

  def rename_attachment(from:, to:)
    execute <<~SQL
      UPDATE active_storage_attachments SET name = #{quote(to)}
      WHERE record_type = 'NewsletterArticle' AND name = #{quote(from)}
    SQL
  end

  def quote(value) = connection.quote(value)
end
