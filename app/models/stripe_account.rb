class StripeAccount < ActiveRecord::Base
  belongs_to :account, polymorphic: true

  validates_uniqueness_of :uid

  ########### DEPRECATED ###########
  #Recipient (Bank Account) Methods
  # def store_ba(bank_account)
  #   self.recipient? ? bank_account.update(self) : create_stripe_recipient(bank_account)
  # end

  # def create_stripe_recipient(bank_account)
  #   recipient = Stripe::Recipient.create(
  #     name: bank_account.name,
  #     type: bank_account.type.downcase,
  #     email: bank_account.email,
  #     tax_id: bank_account.tax_id,
  #     bank_account: bank_account.token
  #   )
  #   update_attribute(:stripe_recipient_id, recipient.id)
  # end

  # def recipient?
  #   stripe_recipient_id.present?
  # end

  # def recipient
  #   Stripe::Recipient.retrieve(stripe_recipient_id) if recipient?
  # end

  #Customer (Credit Card) methods
  def store_cc(credit_card)
    self.customer? ? credit_card.update(self) : create_stripe_customer(credit_card)
  end

  def create_stripe_customer(credit_card)
    customer = Stripe::Customer.create(
      source: credit_card.token,
      description: "Sponsor ##{account.id} Customer Object"
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
