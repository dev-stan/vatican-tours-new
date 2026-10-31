# Preview at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview
  def enquiry
    ContactMailer.with(name: "Maria Rossi", email: "maria@example.com", body: "Hello!\n\nDo you run the Vatican tour on Sundays?").enquiry
  end
end
