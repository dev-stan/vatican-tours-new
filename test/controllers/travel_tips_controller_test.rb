require "test_helper"

class TravelTipsControllerTest < ActionDispatch::IntegrationTest
  test "travel tips lists live guides" do
    get travel_tips_path
    assert_response :success

    assert_select "h1", /Travel Tips/
    assert_select "nav[aria-label=Breadcrumb] [aria-current=page]", "Travel Tips"
    assert_select "article", count: 1
    assert_select "article a[href=?]", travel_tip_path(travel_tips(:meet_the_pope))
    assert_select "header nav a[aria-current=page][href=?]", travel_tips_path
  end

  test "a guide shows its story, booking buttons and live blog posts" do
    tip = travel_tips(:meet_the_pope)
    get travel_tip_path(tip)
    assert_response :success

    assert_select "title", tip.meta_title
    assert_select "meta[name=description][content=?]", tip.meta_description
    assert_select "link[rel=canonical][href=?]", travel_tip_url(tip)
    assert_select "h1", tip.title
    assert_select ".article-body h2", "The Wednesday General Audience"
    assert_select "nav[aria-label=Breadcrumb] a[href=?]", travel_tips_url, text: "Travel Tips"

    assert_select "a[href=?]", tour_path(tours(:ancient_rome)), text: "Book Papal Audience Tickets & Assistance"
    assert_select "a[href=?]", tour_path(tours(:draft_tour)), count: 0

    assert_select "#more-heading"
    assert_select "article a[href=?]", blog_post_path(blog_posts(:papal_tickets))
    assert_select "article a[href=?]", blog_post_path(blog_posts(:future_post)), count: 0
  end

  test "a guide describes itself to search engines" do
    get travel_tip_path(travel_tips(:meet_the_pope))
    article, breadcrumbs = JSON.parse(css_select("script[type='application/ld+json']").first.text)

    assert_equal "Article", article["@type"]
    assert_equal travel_tips(:meet_the_pope).title, article["headline"]
    assert_equal %w[Home Travel\ Tips] << travel_tips(:meet_the_pope).title, breadcrumbs["itemListElement"].pluck("name")
  end

  test "drafts are not found" do
    get travel_tip_path(travel_tips(:draft_tip))
    assert_response :not_found
  end
end
