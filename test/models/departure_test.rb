require "test_helper"

class DepartureTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert departures(:group_open).valid?
  end

  test "starts_at is unique per tour and kind" do
    duplicate = departures(:group_open).dup
    assert_not duplicate.valid?
    duplicate.kind = "private"
    duplicate.starts_at += 1.hour
    assert duplicate.valid?
  end

  test "seats can exceed capacity when the manager overbooks" do
    departure = departures(:group_open)
    departure.update!(seats_booked: 14)
    assert_equal 0, departure.seats_left
    assert_equal 2, departure.overbooked_by
  end

  test "database refuses a negative seat count even when validations are skipped" do
    assert_raises(ActiveRecord::StatementInvalid) do
      departures(:group_open).update_columns(seats_booked: -1)
    end
  end

  test "adjust_seats! never goes below zero" do
    departure = departures(:group_nearly_full)
    departure.adjust_seats!(-50)
    assert_equal 0, departure.reload.seats_booked
  end

  test "seats_left" do
    assert_equal 2, departures(:group_nearly_full).seats_left
  end

  test "bookable needs an open departure past the 24 hour cutoff with seats left" do
    assert departures(:group_open).bookable?
    assert_not departures(:group_closed).bookable?
    assert_not departures(:group_past).bookable?
    assert_not departures(:group_tomorrow_within_cutoff).bookable?
    departures(:group_open).seats_booked = 12
    assert_not departures(:group_open).bookable?
  end

  test "available scope" do
    available = Departure.available
    assert_includes available, departures(:group_open)
    assert_not_includes available, departures(:group_closed)
    assert_not_includes available, departures(:group_past)
    assert_not_includes available, departures(:group_tomorrow_within_cutoff)
  end

  test "for_kind and on_date" do
    date = departures(:group_open).starts_at.to_date
    assert_equal [ departures(:private_open) ], tours(:ancient_rome).departures.for_kind("private").on_date(date).to_a
    assert_empty Departure.on_date(date + 1.day).for_kind("group").where(tour: tours(:ancient_rome))
  end

  test "times are shown in Rome time" do
    assert_equal "Europe/Rome", Time.zone.name
    assert_equal 9, departures(:group_open).starts_at.hour
  end
end
