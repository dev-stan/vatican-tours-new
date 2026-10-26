require "test_helper"

# Runs outside a test transaction so each thread really commits on its own connection.
class Bookings::ConcurrentCreateTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  setup do
    @departure = Departure.create!(tour: tours(:ancient_rome), kind: "group", starts_at: 10.days.from_now.change(hour: 9),
                                   capacity: 12, seats_booked: 10)
  end

  teardown do
    Booking.where(departure: @departure).delete_all
    @departure.delete
  end

  test "only as many bookings as there are seats left succeed" do
    threads = 4
    ready = Concurrent::CountDownLatch.new(threads)
    go = Concurrent::CountDownLatch.new(1)

    results = Array.new(threads) do |i|
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          departure = Departure.find(@departure.id)
          ready.count_down
          go.wait
          Bookings::Create.call(departure: departure, tickets: { ticket_types(:adult).id => 1 },
                                name: "Guest #{i}", email: "guest#{i}@example.com", phone: "+1 555 0100")
        end
      end
    end.tap { ready.wait(5) && go.count_down }.map(&:value)

    assert_equal 2, results.count(&:success?)
    assert_equal [ :sold_out ] * 2, results.reject(&:success?).map(&:error)
    assert_equal 12, @departure.reload.seats_booked
    assert_equal 2, Booking.where(departure: @departure).count
  end
end
