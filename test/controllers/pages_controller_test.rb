require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "home page shows a card for every published tour" do
    unpriced = Tour.create!(title: "Unpriced Tour", slug: "unpriced-tour", location: "Rome", duration_minutes: 90, status: "published")

    get root_path
    assert_response :success

    assert_select "article[data-tour-filter-target=card]", 3
    assert_select "article", text: /Unfinished Tour/, count: 0
    assert_select "article[data-categories=?]", [ "Private Tours", "Small Group", "Wheelchair", "With Kids" ].to_json, text: /Private or Group\s*€65/
    assert_select "article", text: /Trastevere Food Tour.*Private\s*€500/m
    assert_select "article", text: /1 hour 30 min.*#{unpriced.title}.*From\s*€100/m
    assert_no_match "★", response.body
  end

  test "every card links to its tour page" do
    get root_path

    Tour.published.each do |tour|
      assert_select "article a[href=?]", tour_path(tour), text: tour.title
    end
  end
end
