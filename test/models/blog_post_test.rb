require "test_helper"

class BlogPostTest < ActiveSupport::TestCase
  test "links up to its guide only while the guide is live" do
    post = blog_posts(:papal_tickets)
    assert_equal travel_tips(:meet_the_pope), post.guide

    post.travel_tip = travel_tips(:draft_tip)
    assert_nil post.guide
  end

  test "deleting a tour removes its booking buttons" do
    tour = Tour.create!(title: "Short Tour", slug: "short-tour", region: "Rome", duration_minutes: 60, status: "published")
    blog_posts(:papal_tickets).promoted_tours.create!(tour:)
    tour.destroy!

    assert_equal [ promoted_tours(:post_main) ], blog_posts(:papal_tickets).promoted_tours.reload.to_a
  end
end
