require "test_helper"

class NewsletterArticleTest < ActiveSupport::TestCase
  test "live lists published articles already out, newest first" do
    older = NewsletterArticle.create!(title: "Older", slug: "older", status: "published", published_at: 1.week.ago)

    assert_equal [ newsletter_articles(:lagoon_wineries), older ], NewsletterArticle.live.to_a
  end

  test "publishing stamps the date once" do
    article = NewsletterArticle.create!(title: "Fresh", slug: "fresh", status: "draft")
    assert_nil article.published_at

    article.update!(status: "published")
    stamped = article.published_at
    assert_not_nil stamped

    article.update!(title: "Fresher")
    assert_equal stamped, article.reload.published_at
  end

  test "slugs are url-safe and unique" do
    assert_not NewsletterArticle.new(title: "Bad", slug: "Not A Slug").valid?
    assert_not NewsletterArticle.new(title: "Dupe", slug: newsletter_articles(:lagoon_wineries).slug).valid?
  end

  test "only a published tour is promoted" do
    article = newsletter_articles(:lagoon_wineries)
    assert_equal tours(:ancient_rome), article.promoted_tour

    article.tour = tours(:draft_tour)
    assert_nil article.promoted_tour
  end

  test "deleting a tour keeps its articles" do
    tour = Tour.create!(title: "Short Tour", slug: "short-tour", region: "Rome", duration_minutes: 60)
    article = NewsletterArticle.create!(title: "Promo", slug: "promo", tour:)
    tour.destroy!

    assert_nil article.reload.tour
  end
end
