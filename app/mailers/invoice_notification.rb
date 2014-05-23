class InvoiceNotification < ActionMailer::Base
  default from: "no-reply@cakefundraising.com"

  def new_invoice(invoice, user)
    @invoice = invoice
    @receiver = user.decorate
    mail(to: @receiver.email, subject: 'You have pending invoices.')  
  end
end
