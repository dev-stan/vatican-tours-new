require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "the newsletter lists live articles with a breadcrumb" do
    get newsletter_articles_path
    assert_response :success

    assert_select "h1", /Travel Newsletter \/\s*Stories/
    assert_select "nav[aria-label=Breadcrumb] a[href=?]", root_path, text: "Home"
    assert_select "nav[aria-label=Breadcrumb] [aria-current=page]", "Newsletter"
    assert_select "article a[href=?]", newsletter_article_path(newsletter_articles(:lagoon_wineries)), text: newsletter_articles(:lagoon_wineries).title
    assert_select "article", count: 1
    assert_select "header nav a[aria-current=page][href=?]", newsletter_articles_path
  end

  test "an article shows its story and promotes its tour" do
    get newsletter_article_path(newsletter_articles(:lagoon_wineries))
    assert_response :success

    assert_select "h1", newsletter_articles(:lagoon_wineries).title
    assert_select ".article-body h2", "The golden grape"
    assert_select "#tour-heading", "#{tours(:ancient_rome).title} tour"
    assert_select "a[href=?]", tour_path(tours(:ancient_rome)), text: "Learn more about the tour"
  end

  test "an article without a published tour has no promo" do
    newsletter_articles(:lagoon_wineries).update!(tour: tours(:draft_tour))

    get newsletter_article_path(newsletter_articles(:lagoon_wineries))
    assert_select "#tour-heading", count: 0
    assert_select "a", text: "Learn more about the tour", count: 0
  end

  test "drafts and future articles are not found" do
    get newsletter_article_path(newsletter_articles(:draft_story))
    assert_response :not_found

    get newsletter_article_path(newsletter_articles(:future_story))
    assert_response :not_found
  end
end
