module Stripable
  extend ActiveSupport::Concern

  included do
    has_one :stripe_account, as: :account, dependent: :destroy
  end

  #### Stripe Account
  def stripe_account?
    stripe_account.present?
  end

  def create_stripe_account(auth)
    self.build_stripe_account(
      uid: auth.uid,
      stripe_publishable_key: auth.info.stripe_publishable_key,
      token: auth.credentials.token
    ).save
  end
end