require "test_helper"

class BlogPostsControllerTest < ActionDispatch::IntegrationTest
  test "the blog lists live posts" do
    get blog_posts_path
    assert_response :success

    assert_select "h1", /Blog/
    assert_select "article", count: 1
    assert_select "article a[href=?]", blog_post_path(blog_posts(:papal_tickets))
  end

  test "a post shows its story, booking button and links up to its guide" do
    post = blog_posts(:papal_tickets)
    get blog_post_path(post)
    assert_response :success

    assert_select "title", "#{post.title} — Vatican Tours Inc"
    assert_select "meta[name=description][content=?]", post.excerpt
    assert_select ".article-body h2", "What a papal audience ticket gets you"
    assert_select "a[href=?]", tour_path(tours(:ancient_rome)), text: "Book #{tours(:ancient_rome).title}"
    assert_select "#guide-heading a[href=?]", travel_tip_path(travel_tips(:meet_the_pope))
  end

  test "a post whose guide isn't live doesn't link to it" do
    blog_posts(:papal_tickets).update!(travel_tip: travel_tips(:draft_tip))

    get blog_post_path(blog_posts(:papal_tickets))
    assert_select "#guide-heading", count: 0
  end

  test "future posts are not found" do
    get blog_post_path(blog_posts(:future_post))
    assert_response :not_found
  end
end
