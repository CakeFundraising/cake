class InvoiceNotification < AsyncMailer
  default from: "no-reply@cakecausemarketing.com"

  def new_invoice(invoice_id, user_id)
    @invoice = find_invoice(invoice_id).decorate
    @pledge = @invoice.pledge
    @receiver = find_user(user_id).decorate
    mail(to: @receiver.email, subject: 'You have outstanding invoices.')  
  end

  def payment_charge(invoice_id, user_id)
    @invoice = find_invoice(invoice_id).decorate
    @receiver = find_user(user_id).decorate
    mail(to: @receiver.email, subject: 'Your invoice has been paid.')
  end

  def payment_transfer(invoice_id, user_id)
    @invoice = find_invoice(invoice_id).decorate
    @receiver = find_user(user_id).decorate
    @pledge = @invoice.pledge
    @amount = @invoice.payment.transfers.first.amount
    @sp = @invoice.sponsor
    mail(to: @receiver.email, subject: 'Transfer scheduled.')
  end

  #QP payments
  def quick_payment_charge(invoice_id, user_id)
    @invoice = find_invoice(invoice_id).decorate
    @receiver = find_user(user_id).decorate
    mail(to: @receiver.email, subject: 'Thank you!')
  end

  protected

  def find_invoice(id)
    Invoice.find(id)
  end
end
