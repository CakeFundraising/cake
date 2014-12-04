class ContactMailer < MailForm::Base
  include Formats
  
  attribute :name,      validate: true
  attribute :email,     validate: EMAIL_REGEX
  attribute :phone
  attribute :message,   validate: true

  def headers
    {
      subject: "Contact from #{name}",
      #to: 'joe@cakefundraising.com',
      to: 'bismark64@gmail.com',
      from: %("CakeFundraising" <no-reply@cakefundraising.com>)
    }
  end  
end