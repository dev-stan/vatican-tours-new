class Avo::Filters::BookingStatus < Avo::Filters::SelectFilter
  self.name = "Status"

  def apply(request, query, value)
    ::Booking.statuses.key?(value) ? query.where(status: value) : query
  end

  # The bookings list opens on what needs an answer. Clear the filter to see everything.
  def default
    "pending"
  end

  def options
    ::Booking.statuses.keys.index_by(&:to_sym).transform_values(&:humanize)
  end
end
