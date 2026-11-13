# Newsletter posts get their own name so future blog-style models don't collide with a generic "Article".
# Action Text bodies and Active Storage images point at their owner by class name (record_type), so those rows are
# renamed too. Otherwise every post would lose its body and photos.
class RenameArticlesToNewsletterArticles < ActiveRecord::Migration[8.1]
  def up
    rename_table :articles, :newsletter_articles
    remove_check_constraint :newsletter_articles, name: "articles_status_valid"
    add_check_constraint :newsletter_articles, "status IN ('draft', 'published')", name: "newsletter_articles_status_valid"
    rename_record_type "Article", "NewsletterArticle"
  end

  def down
    rename_record_type "NewsletterArticle", "Article"
    remove_check_constraint :newsletter_articles, name: "newsletter_articles_status_valid"
    add_check_constraint :newsletter_articles, "status IN ('draft', 'published')", name: "articles_status_valid"
    rename_table :newsletter_articles, :articles
  end

  private

  def rename_record_type(from, to)
    %w[action_text_rich_texts active_storage_attachments].each do |table|
      execute "UPDATE #{table} SET record_type = #{quote(to)} WHERE record_type = #{quote(from)}"
    end
  end

  def quote(value) = connection.quote(value)
end
