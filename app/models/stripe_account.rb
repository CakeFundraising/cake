class StripeAccount < ActiveRecord::Base
  belongs_to :fundraiser

  def create_stripe_recipient(bank_account)
    recipient = Stripe::Recipient.create(
      name: bank_account.name,
      type: bank_account.type.downcase,
      email: bank_account.email,
      tax_id: bank_account.tax_id,
      bank_account: bank_account.token
    )
    update_attribute(:stripe_recipient_id, recipient.id)
  end

  def recipient?
    stripe_recipient_id.present?
  end

  def recipient
    Stripe::Recipient.retrieve(stripe_recipient_id) if recipient?
  end
end
