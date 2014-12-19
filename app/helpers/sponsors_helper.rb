module SponsorsHelper
  def invoice_pay_button(invoice)
    if current_sponsor.decorate.stripe_customer?
      link_to "Pay", invoice_payment_path(payment: {item_id: invoice.object.id}), method: :post, class:'btn btn-primary btn-sm pay_button'
    else
      link_to "Pay", nil, class:"btn btn-primary btn-sm pay_button invoice_#{invoice.object.id}"
    end
  end
end
