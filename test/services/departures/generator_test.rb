require "test_helper"

class Departures::GeneratorTest < ActiveSupport::TestCase
  setup do
    @tour = Tour.create!(title: "Night Walk", slug: "night-walk", location: "Rome", duration_minutes: 120)
    travel_to Time.zone.local(2027, 3, 1, 8)
  end

  def generate(**options)
    Departures::Generator.call(tour: @tour, kind: "group", times: %w[09:00 16:00], days: %i[mon wed],
                               capacity: 10, from: "2027-03-01", to: "2027-03-14", **options)
  end

  test "creates departures on the chosen days and times" do
    assert_equal 8, generate # 4 Mondays/Wednesdays x 2 times
    departures = @tour.departures.for_kind("group").chronological
    assert_equal [ 1, 3 ], departures.map { |departure| departure.starts_at.wday }.uniq.sort
    assert_equal %w[09:00 16:00], departures.map { |departure| departure.starts_at.strftime("%H:%M") }.uniq.sort
    assert departures.all? { |departure| departure.capacity == 10 && departure.seats_booked.zero? && departure.status_open? }
  end

  test "is idempotent and leaves existing departures alone" do
    generate
    first = @tour.departures.chronological.first
    first.update!(seats_booked: 4, status: "closed")

    assert_no_difference -> { Departure.count } do
      assert_equal 0, generate(capacity: 20)
    end
    first.reload
    assert_equal [ 10, 4, "closed" ], [ first.capacity, first.seats_booked, first.status ]
  end

  test "fills in only the missing departures" do
    generate(to: "2027-03-07")
    assert_equal 4, generate
  end

  test "skips past times and closed dates" do
    travel_to Time.zone.local(2027, 3, 1, 12)
    # Mon 1st 09:00 is already past and Wed 10th is skipped: 1 + 2 + 2 left.
    assert_equal 5, generate(skip_dates: [ "2027-03-10" ])
  end

  test "keeps Rome wall-clock time across the DST change" do
    generate(days: %i[sat sun mon], times: %w[09:00], from: "2027-03-27", to: "2027-03-29")
    starts = @tour.departures.chronological.map(&:starts_at)

    assert_equal [ "09:00" ] * 3, starts.map { |starts_at| starts_at.strftime("%H:%M") }
    assert_equal %w[08:00 07:00 07:00], starts.map { |starts_at| starts_at.utc.strftime("%H:%M") }
    assert_equal %w[+01:00 +02:00 +02:00], starts.map(&:formatted_offset)
  end

  test "rejects bad input" do
    assert_raises(ArgumentError) { generate(kind: "vip") }
    assert_raises(ArgumentError) { generate(times: %w[9am]) }
    assert_raises(ArgumentError) { generate(days: %i[funday]) }
    assert_raises(ArgumentError) { generate(capacity: 0) }
  end
end
