module NewsletterArticlesHelper
  Callout = Data.define(:paragraphs, :buttons)
  Button = Data.define(:label, :url)

  # The box under a newsletter article, always headed "Travel with us": a few lines of text, then one button per thing it promotes — its link,
  # its tour and its linked tours, each tour named on its button. Only tours on sale count. Nil when there's nothing.
  def newsletter_callout(article)
    buttons = []
    buttons << Button.new(article.promo_button.presence || "Learn more", article.promo_url) if article.promoted_link?
    tours = [ article.promoted_tour, *article.bookable_promotions.map(&:tour) ].compact.uniq
    buttons.concat(tours.map { |tour| Button.new(tour.title, tour_path(tour)) })
    return if buttons.empty?

    Callout.new(paragraphs: article.promo_text.to_s.split(/\R{2,}/).map(&:strip).compact_blank,
                buttons:)
  end
end
