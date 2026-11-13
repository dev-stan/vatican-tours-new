require "test_helper"

# Publishable is shared by all post types; it's tested here once, on travel tips.
class TravelTipTest < ActiveSupport::TestCase
  test "live lists published guides already out, newest first" do
    newer = TravelTip.create!(title: "Newer", slug: "newer", status: "published", published_at: 1.day.ago)
    TravelTip.create!(title: "Later", slug: "later", status: "published", published_at: 1.day.from_now)

    assert_equal [ newer, travel_tips(:meet_the_pope) ], TravelTip.live.to_a
    assert travel_tips(:meet_the_pope).live?
    assert_not travel_tips(:draft_tip).live?
  end

  test "publishing stamps the date once" do
    tip = TravelTip.create!(title: "Fresh", slug: "fresh")
    assert_nil tip.published_at

    tip.update!(status: "published")
    stamped = tip.published_at
    tip.update!(title: "Fresher")
    assert_equal stamped, tip.reload.published_at
  end

  test "slugs are url-safe and unique, meta tags fit search results" do
    assert_not TravelTip.new(title: "Bad", slug: "Not A Slug").valid?
    assert_not TravelTip.new(title: "Dupe", slug: travel_tips(:meet_the_pope).slug).valid?
    assert_not TravelTip.new(title: "Long", slug: "long", meta_title: "x" * 61).valid?
    assert_not TravelTip.new(title: "Long", slug: "long", meta_description: "x" * 156).valid?
    assert TravelTip.new(title: "Fits", slug: "fits", meta_title: "x" * 60, meta_description: "x" * 155).valid?
  end

  test "a post shows an updated date only when it changed on a later day" do
    tip = travel_tips(:meet_the_pope)
    tip.update_column :updated_at, tip.published_at
    assert_nil tip.revised_on

    tip.update_column :updated_at, 1.day.ago
    assert_equal 1.day.ago.to_date, tip.revised_on
  end

  test "booking buttons are ordered and skip tours that aren't on sale" do
    assert_equal [ promoted_tours(:guide_main) ], travel_tips(:meet_the_pope).bookable_promotions
    assert_equal "Book Papal Audience Tickets & Assistance", promoted_tours(:guide_main).button_label
    assert_equal "Book #{tours(:ancient_rome).title}", promoted_tours(:post_main).button_label
  end

  test "deleting a guide keeps its blog posts and drops its buttons" do
    button = promoted_tours(:guide_main)
    travel_tips(:meet_the_pope).destroy!

    assert_nil blog_posts(:papal_tickets).reload.travel_tip
    assert_not PromotedTour.exists?(button.id)
  end
end
