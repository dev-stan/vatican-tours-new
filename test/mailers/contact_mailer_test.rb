require "test_helper"

class ContactMailerTest < ActionMailer::TestCase
  test "enquiry goes to the agency with the customer as reply-to" do
    mail = ContactMailer.with(name: "Maria Rossi", email: "maria@example.com", body: "Do you run tours on Sundays?").enquiry

    assert_equal [ BookingMailer.agency_email ], mail.to
    assert_equal [ "maria@example.com" ], mail.reply_to
    assert_equal "Website enquiry from Maria Rossi", mail.subject
    [ mail.html_part, mail.text_part ].map { |part| part.body.to_s }.each do |body|
      assert_includes body, "Maria Rossi"
      assert_includes body, "Do you run tours on Sundays?"
    end
  end
end
