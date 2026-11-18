module NewsletterArticlesHelper
  Promo = Data.define(:kicker, :title, :paragraphs, :url, :button)

  # What the box under a newsletter article shows: its tour while on sale, else its link, else nothing.
  def newsletter_promo(article)
    if (tour = article.promoted_tour)
      Promo.new(kicker: "Visit with us", title: "#{tour.title} tour", paragraphs: tour_finer_details(tour),
                url: tour_path(tour), button: "Learn more about the tour")
    elsif article.promoted_link?
      Promo.new(kicker: "Travel with us", title: article.promo_title,
                paragraphs: article.promo_text.to_s.split(/\R{2,}/).map(&:strip).compact_blank,
                url: article.promo_url, button: article.promo_button.presence || "Learn more")
    end
  end
end
