require "test_helper"

class ContactsControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper

  test "shows the contact form and channels" do
    get contact_path
    assert_response :success
    assert_select "form[action=?]", contact_path
    assert_select "a[href=?]", "mailto:#{ContactHelper::CONTACT_EMAIL}"
  end

  test "a valid message is emailed to the agency" do
    assert_enqueued_email_with ContactMailer, :enquiry,
        params: { name: "Maria Rossi", email: "maria@example.com", body: "Do you run tours on Sundays?" } do
      post contact_path, params: { contact_message: { name: " Maria Rossi ", email: "Maria@Example.com ", body: "Do you run tours on Sundays?" } }
    end
    assert_redirected_to contact_path

    follow_redirect!
    assert_select "[role=status]", /usually answer the same day/
    assert_select "form[action=?]", contact_path, count: 0
  end

  test "an invalid message re-renders the form with errors" do
    assert_no_enqueued_emails do
      post contact_path, params: { contact_message: { name: "", email: "not-an-email", body: "" } }
    end
    assert_response :unprocessable_entity
    assert_select "#name-error", "Name can't be blank"
    assert_select "#email-error", "Email is invalid"
    assert_select "#body-error", "Message can't be blank"
  end

  test "a filled honeypot looks sent but sends nothing" do
    assert_no_enqueued_emails do
      post contact_path, params: { contact_message: { name: "Bot", email: "bot@example.com", body: "Buy now", website: "http://spam.example" } }
    end
    assert_redirected_to contact_path
  end
end
