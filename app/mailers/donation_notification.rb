class DonationNotification < AsyncMailer
  default from: "no-reply@cakefundraising.com"

  def charge_succeeded(charge)
    @amount = number_to_currency(charge.amount.to_i/100)
    @email = charge.card.name
    mail(to: @email, subject: 'Thank you for your donation!')
  end
end