class InvoiceNotification < ActionMailer::Base
  default from: "no-reply@cakefundraising.com"

  def new_invoice(invoice, user)
    @invoice = invoice.decorate
    @receiver = user.decorate
    mail(to: @receiver.email, subject: 'You have outstanding invoices.')  
  end

  def payment_charge(invoice, user)
    @invoice = invoice.decorate
    @receiver = user.decorate
    mail(to: @receiver.email, subject: 'Your invoice has been paid.')
  end
end
