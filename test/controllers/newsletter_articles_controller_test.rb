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
    assert_select "#promo-heading", "Travel with us"
    assert_select "section[aria-labelledby=promo-heading] a[href=?]", tour_path(tours(:ancient_rome)), text: /#{tours(:ancient_rome).title}/
  end

  test "an article without a published tour has no promo" do
    newsletter_articles(:lagoon_wineries).update!(tour: tours(:draft_tour))

    get newsletter_article_path(newsletter_articles(:lagoon_wineries))
    assert_select "#promo-heading", count: 0
  end

  test "an article can promote a link instead of a tour" do
    newsletter_articles(:lagoon_wineries).update!(
      tour: nil, promo_url: "/?region=tuscany", promo_title: "Private Tuscany Tours",
      promo_text: "Chianti and the Val d’Orcia.\n\nDay trips from Florence or Rome.", promo_button: "Explore our Tuscany tours"
    )

    get newsletter_article_path(newsletter_articles(:lagoon_wineries))
    assert_select "#promo-heading", "Travel with us"
    assert_select "section[aria-labelledby=promo-heading] p", text: /Day trips from Florence/
    assert_select "section[aria-labelledby=promo-heading] a[href=?]", "/?region=tuscany", text: /Explore our Tuscany tours/
    assert_select "section[aria-labelledby=promo-heading] a", count: 1
  end

  test "the tour and linked tours each get a button named after the tour, published ones only" do
    article = newsletter_articles(:lagoon_wineries)
    article.promoted_tours.create!(tour: tours(:ancient_rome), position: 1)
    article.promoted_tours.create!(tour: tours(:draft_tour), position: 2)
    article.promoted_tours.create!(tour: tours(:food_tour), position: 3)

    get newsletter_article_path(article)
    assert_select "section[aria-labelledby=promo-heading] a", count: 2
    assert_select "section[aria-labelledby=promo-heading] a[href=?]", tour_path(tours(:ancient_rome)), count: 1
    assert_select "section[aria-labelledby=promo-heading] a[href=?]", tour_path(tours(:food_tour)), text: /#{tours(:food_tour).title}/
  end

  test "an article without a tour or link has no callout" do
    newsletter_articles(:lagoon_wineries).update!(tour: nil)

    get newsletter_article_path(newsletter_articles(:lagoon_wineries))
    assert_select "#promo-heading", count: 0
  end

  test "drafts and future articles are not found" do
    get newsletter_article_path(newsletter_articles(:draft_story))
    assert_response :not_found

    get newsletter_article_path(newsletter_articles(:future_story))
    assert_response :not_found
  end
end
