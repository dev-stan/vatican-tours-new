require "test_helper"

class TicketTypeTest < ActiveSupport::TestCase
  test "fixture is valid" do
    assert ticket_types(:adult).valid?
  end

  test "kind must be group or private" do
    ticket_type = ticket_types(:adult)
    ticket_type.kind = "vip"
    assert_not ticket_type.valid?
    assert ticket_types(:private_group).kind_private?
  end

  test "price cannot be negative" do
    ticket_type = ticket_types(:adult)
    ticket_type.price_cents = -1
    assert_not ticket_type.valid?
  end

  test "max age must not be below min age" do
    ticket_type = ticket_types(:child)
    ticket_type.max_age = 5
    assert_not ticket_type.valid?
    assert_includes ticket_type.errors[:max_age], "must be greater than or equal to min age"
  end

  test "name is unique per tour and kind" do
    duplicate = ticket_types(:adult).dup
    assert_not duplicate.valid?
    duplicate.kind = "private"
    assert duplicate.valid?
  end

  test "adult means 18 and over" do
    assert ticket_types(:adult).adult?
    assert_not ticket_types(:child).adult?
    assert_not ticket_types(:private_group).adult?
  end

  test "for_kind" do
    assert_equal %w[Adult Child Infant], tours(:ancient_rome).ticket_types.for_kind("group").map(&:name)
  end
end
