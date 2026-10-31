class ContactMailer < ApplicationMailer
  # Plain params rather than a ContactMessage, so the job can serialize them for deliver_later.
  def enquiry
    @name, @email, @body = params.values_at(:name, :email, :body)
    mail to: BookingMailer.agency_email, reply_to: email_address_with_name(@email, @name),
         subject: "Website enquiry from #{@name}"
  end
end
