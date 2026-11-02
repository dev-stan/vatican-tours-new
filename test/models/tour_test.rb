require "test_helper"

class TourTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert tours(:ancient_rome).valid?
  end

  test "requires title, location and slug" do
    tour = Tour.new
    assert_not tour.valid?
    assert_includes tour.errors[:title], "can't be blank"
    assert_includes tour.errors[:location], "can't be blank"
    assert_includes tour.errors[:slug], "can't be blank"
  end

  test "slug is unique and url-safe" do
    tour = tours(:ancient_rome).dup
    assert_not tour.valid?
    assert_includes tour.errors[:slug], "has already been taken"

    tour.slug = "Ancient Rome!"
    assert_not tour.valid?
    assert_includes tour.errors[:slug], "is invalid"
  end

  test "duration must be positive" do
    tour = tours(:ancient_rome)
    tour.duration_minutes = 0
    assert_not tour.valid?
  end

  test "status is draft or published" do
    tour = tours(:ancient_rome)
    tour.status = "archived"
    assert_not tour.valid?
    assert_equal "draft", Tour.new.status
  end

  test "languages must be known codes" do
    tour = tours(:ancient_rome)
    tour.languages = %w[en xx]
    assert_not tour.valid?
    assert_match "xx", tour.errors[:languages].first
  end

  test "tags must all be in the allowed list" do
    tour = tours(:ancient_rome)
    tour.tags = %w[wheelchair rooftop]
    assert_not tour.valid?
    assert_match "rooftop", tour.errors[:tags].first

    tour.tags = Tour::TAGS
    assert tour.valid?
  end

  test "tags are normalized and default to empty" do
    assert_equal [], Tour.new.tags
    tour = Tour.new(tags: [ :wine, "wine", "", nil ])
    assert_equal %w[wine], tour.tags
  end

  test "content blocks come back in position order" do
    tour = tours(:ancient_rome)
    tour.highlights.create!(title: "Second", position: 2)
    tour.highlights.create!(title: "First", position: 1)
    assert_equal %w[First Second], tour.reload.highlights.map(&:title)
  end

  test "tagged_with matches tours that have all the tags, not any" do
    assert_equal [ tours(:ancient_rome), tours(:draft_tour) ].sort, Tour.tagged_with("wheelchair", "with_kids").sort
    assert_equal [ tours(:food_tour) ], Tour.tagged_with("with_kids", "wine").to_a
    assert_empty Tour.tagged_with("wheelchair", "wine")
    assert_equal 3, Tour.tagged_with("with_kids").count
  end

  test "tagged_with accepts an array and no tags at all" do
    assert_equal [ tours(:food_tour) ], Tour.tagged_with(%w[food_and_cooking wine]).to_a
    assert_equal Tour.count, Tour.tagged_with.count
  end

  test "filter returns only published tours" do
    assert_equal [ tours(:ancient_rome), tours(:food_tour) ].sort, Tour.filter.sort
  end

  test "filter by tags" do
    assert_equal [ tours(:ancient_rome) ], Tour.filter(tags: %w[wheelchair with_kids]).to_a
    assert_equal [ tours(:ancient_rome), tours(:food_tour) ].sort, Tour.filter(tags: %w[with_kids]).sort
  end

  test "filter by kind" do
    assert_equal [ tours(:ancient_rome) ], Tour.filter(kind: "group").to_a
    assert_equal [ tours(:ancient_rome), tours(:food_tour) ].sort, Tour.filter(kind: "private").sort
  end

  test "filter by group size uses seats left on bookable departures" do
    # Ancient Rome group_open has 12 free; food tour has only a private slot (1 seat).
    assert_equal [ tours(:ancient_rome) ], Tour.filter(group_size: 12).to_a
    assert_empty Tour.filter(group_size: 13)

    departures(:group_open).update!(seats_booked: 11)
    # group_tomorrow_within_cutoff has 12 seats but can no longer be booked.
    assert_empty Tour.filter(group_size: 12)
    assert_equal [ tours(:ancient_rome) ], Tour.filter(group_size: 2).to_a
  end

  test "filter by group size ignores closed and past departures" do
    Departure.where(tour: tours(:ancient_rome)).where.not(id: [ departures(:group_closed), departures(:group_past) ].map(&:id))
             .update_all(status: "closed")
    assert_empty Tour.filter(kind: "group", group_size: 1)
  end

  test "filter combines everything without duplicates" do
    result = Tour.filter(tags: %w[with_kids], kind: "private", group_size: 1)
    assert_equal [ tours(:ancient_rome), tours(:food_tour) ].sort, result.sort
    # Ancient Rome has several matching ticket types and departures, but appears once.
    assert_equal result.map(&:id).uniq, result.map(&:id)
    assert_equal [ tours(:ancient_rome) ], Tour.filter(tags: %w[wheelchair], kind: "group", group_size: 4).to_a
  end

  test "filter ignores blank values from params" do
    assert_equal Tour.filter.sort, Tour.filter(tags: [ "" ], kind: "", group_size: "").sort
  end

  test "starting price is the cheapest adult or private ticket" do
    # Child (€45) and infant (€0) tickets don't count.
    assert_equal 65_00, tours(:ancient_rome).starting_price_cents
    assert_equal 500_00, tours(:food_tour).starting_price_cents
    assert_nil Tour.new.starting_price_cents
    assert_equal 390_00, tours(:ancient_rome).starting_price_cents("private")
    assert_equal 65_00, tours(:ancient_rome).starting_price_cents("group")
  end
end
