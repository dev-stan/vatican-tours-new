class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name(
    Rails.application.credentials.dig(:agency, :email).presence || "bookings@vaticantours.example",
    "Vatican Tours Inc"
  )
  helper MoneyHelper
  layout "mailer"
end
