class MailersController < ApplicationController
  def contact
    @contact = ContactMailer.new(params[:contact_mailer])
    @contact.request = request
    
    if @contact.deliver
      redirect_to root_path, notice: 'Thank you for your message!'
    else 
      flash[:alert] = 'There was an error when sending your message. Check your form fields.'
      render 'about/contact' 
    end
  end
end