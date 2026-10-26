module Departures
  # Creates the missing departures for a tour; existing ones are left untouched.
  #
  #   Departures::Generator.call(tour:, kind: "group", times: %w[09:00 10:30], days: %i[mon tue],
  #                              capacity: 12, from: Date.current, to: 8.weeks.from_now.to_date)
  #
  # Times are Rome wall-clock times, so 09:00 stays 09:00 across DST changes.
  # Returns the number of departures created.
  class Generator
    DAYS = %i[sun mon tue wed thu fri sat].freeze

    def self.call(...) = new(...).call

    def initialize(tour:, kind:, times:, days:, capacity:, from:, to:, skip_dates: [])
      @tour = tour
      @kind = kind.to_s
      @times = Array(times).map { |time| parse_time(time) }
      @wdays = Array(days).map { |day| DAYS.index(day.to_s.downcase.first(3).to_sym) || raise(ArgumentError, "Unknown day: #{day}") }
      @capacity = Integer(capacity)
      @dates = Date.parse(from.to_s)..Date.parse(to.to_s)
      @skip_dates = Array(skip_dates).map { |date| Date.parse(date.to_s) }

      raise ArgumentError, "Unknown kind: #{kind}" unless Departure.kinds.key?(@kind)
      raise ArgumentError, "Capacity must be positive" unless @capacity.positive?
    end

    def call
      rows = starts.map { |starts_at| { tour_id: @tour.id, kind: @kind, starts_at: starts_at, capacity: @capacity } }
      return 0 if rows.empty?

      Departure.insert_all(rows, unique_by: %i[tour_id kind starts_at]).length
    end

    private
      def starts
        now = Time.current
        @dates.select { |date| @wdays.include?(date.wday) && !@skip_dates.include?(date) }
              .flat_map { |date| @times.map { |hour, min| Time.zone.local(date.year, date.month, date.day, hour, min) } }
              .select { |starts_at| starts_at > now }
      end

      def parse_time(time)
        match = time.to_s.match(/\A(\d{1,2}):(\d{2})\z/) or raise ArgumentError, "Time must be HH:MM: #{time}"
        hour, min = match[1].to_i, match[2].to_i
        raise ArgumentError, "Invalid time: #{time}" unless hour < 24 && min < 60
        [ hour, min ]
      end
  end
end
