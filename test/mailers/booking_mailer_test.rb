require "test_helper"

class BookingMailerTest < ActionMailer::TestCase
  setup do
    @booking = bookings(:confirmed)
    @when = departures(:group_nearly_full).starts_at.to_fs(:tour)
  end

  test "request receipt goes to the customer and says it is not confirmed" do
    mail = BookingMailer.request_received(@booking)

    assert_equal [ "maria@example.com" ], mail.to
    assert_equal "We’ve received your booking request – Ancient Rome Walking Tour (VTI-AAAA)", mail.subject
    [ mail.html_part, mail.text_part ].map { |part| part.body.to_s }.each do |body|
      assert_includes body, "VTI-AAAA"
      assert_includes body, @when
      assert_includes body, "10:30"
      assert_includes body, "€175"
      assert_includes body, "2 × Adult"
      assert_includes body, "€130"
      assert_includes body, "Outside the Colosseo metro station"
      assert_match(/not confirmed yet/i, body)
      assert_includes body, "within 12 hours"
      assert_includes body, "http://example.com/tours/#{@booking.tour.slug}/booked/"
    end
  end

  test "agency notification has the tour, time, guests and contact details" do
    mail = BookingMailer.agency_notification(@booking)

    assert_equal [ BookingMailer.agency_email ], mail.to
    assert_equal [ "maria@example.com" ], mail.reply_to
    assert_match "New booking request VTI-AAAA", mail.subject
    assert_match "3 guests", mail.subject
    body = mail.text_part.body.to_s
    assert_includes mail.html_part.body.to_s, "Open in panel"
    assert_includes body, "http://example.com/admin/resources/bookings/#{@booking.id}"
    [ "Ancient Rome Walking Tour", @when, "Guests:    3", "Maria Rossi", "maria@example.com", "+39 333 1234567", "€175" ].each do |text|
      assert_includes body, text
    end
  end
end
