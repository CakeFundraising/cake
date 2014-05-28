class StripeAccount < ActiveRecord::Base
  belongs_to :account, polymorphic: true

  #Recipient Methods
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

  #Customer methods
  def create_stripe_customer(credit_card)
    customer = Stripe::Customer.create(
      card: credit_card.token,
      description: "Sponsor ##{account.id} customer"
    )
    update_attribute(:stripe_customer_id, customer.id)
  end

  def customer?
    stripe_customer_id.present?
  end

  def customer
    Stripe::Customer.retrieve(stripe_customer_id) if customer?
  end
end
