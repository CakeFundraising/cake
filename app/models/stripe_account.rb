class StripeAccount < ActiveRecord::Base
  belongs_to :fundraiser

  def create_stripe_recipient(recipient_params)
    recipient = Stripe::Recipient.create(
      name: recipient_params[:name],
      type: recipient_params[:type].downcase,
      email: recipient_params[:email],
      bank_account: recipient_params[:token]
    )
    update_attribute(:stripe_recipient_id, recipient.id)
  end
end
