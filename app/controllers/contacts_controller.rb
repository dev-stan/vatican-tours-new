class ContactsController < ApplicationController
  def show
    @contact_message = ContactMessage.new
  end

  def create
    @contact_message = ContactMessage.new(contact_params)

    if @contact_message.spam?
      sent
    elsif @contact_message.valid?
      ContactMailer.with(name: @contact_message.name, email: @contact_message.email, body: @contact_message.body).enquiry.deliver_later
      sent
    else
      render :show, status: :unprocessable_entity
    end
  end

  private
    def sent
      redirect_to contact_path, notice: "Grazie! We’ve got your message and usually answer the same day.", status: :see_other
    end

    def contact_params
      params.expect(contact_message: %i[name email body website])
    end
end
