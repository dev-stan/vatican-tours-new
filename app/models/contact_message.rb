# A message from the contact page. Not stored: it is emailed to the agency, who reply from their inbox.
class ContactMessage
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :name, :string
  attribute :email, :string
  attribute :body, :string
  # Hidden from people; bots that fill every field land here and are silently dropped.
  attribute :website, :string

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :body, presence: true, length: { maximum: 5000 }

  def name = super&.strip
  def email = super&.strip&.downcase
  def body = super&.strip

  def spam? = website.present?
end
