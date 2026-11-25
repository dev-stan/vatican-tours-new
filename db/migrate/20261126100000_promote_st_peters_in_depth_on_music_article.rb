# The "Music of St Peter's Basilica" newsletter article promotes the St. Peter's Basilica in Depth tour in its
# Travel with us box. Left alone if the article or the tour isn't in this database.
class PromoteStPetersInDepthOnMusicArticle < ActiveRecord::Migration[8.1]
  class Article < ActiveRecord::Base
    self.table_name = "newsletter_articles"
  end

  class Tour < ActiveRecord::Base
    self.table_name = "tours"
  end

  ARTICLE_SLUG = "music-of-st-peters-basilica"
  TOUR_SLUG = "highlights-st-peters-basilica-dome-papal-tombs"

  def up
    article = Article.find_by(slug: ARTICLE_SLUG) or return say("#{ARTICLE_SLUG}: article not found, skipped")
    tour = Tour.find_by(slug: TOUR_SLUG) or return say("#{TOUR_SLUG}: tour not found, skipped")
    article.update_columns(tour_id: tour.id, promo_url: nil)
  end

  def down
    article = Article.find_by(slug: ARTICLE_SLUG)
    article&.update_columns(tour_id: nil) if article&.tour_id == Tour.find_by(slug: TOUR_SLUG)&.id
  end
end
