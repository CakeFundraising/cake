module PaymentsHelper
  #Conditionals
  def recipient_stripe_account?
    self.recipient.stripe_account.present? and self.recipient.stripe_account.stripe_recipient_id.present?
  end

  def cakester_stripe_account?
    self.item.cakester.stripe_account.present? and self.item.cakester.stripe_account.stripe_recipient_id.present?
  end

  def balance_available?
    available_amount = self.get_stripe_balance

    required_amount = self.item.net_amount_cents
    required_amount += self.item.cakester_commission_cents if self.has_cakester?

    available_amount > required_amount
  end

  #Charges
  def stripe_charge_card
    charge = Stripe::Charge.create(
      amount: self.total_cents,
      currency: self.total_currency.downcase,
      card: self.card_token,
      customer: self.customer_id,
      description: "CakeCauseMarketing.com #{item_type} ##{item_id} Payment",
    )
    self.store_charge(charge) 
  end

  def store_charge(stripe_charge) 
    balance_transaction = Stripe::BalanceTransaction.retrieve(stripe_charge.balance_transaction)

    self.charges.build(
      stripe_id: stripe_charge.id,
      balance_transaction_id: stripe_charge.balance_transaction,
      kind: stripe_charge.object,
      amount_cents: stripe_charge.amount,
      amount_currency: stripe_charge.currency.upcase,
      total_fee_cents: balance_transaction.fee,
      paid: stripe_charge.paid,
      captured: stripe_charge.captured,
      fee_details: balance_transaction.fee_details.map(&:to_hash)
    )
  end

  #Transfers
  def stripe_transfer
    if has_cakester? and cakester_stripe_account?
      ck_transfer =  Stripe::Transfer.create(
        amount: self.item.cakester_commission_cents,
        currency: self.total_currency.downcase,
        recipient: self.item.cakester.stripe_account.stripe_recipient_id,
        statement_description: "CakeCauseMarketing.com Invoice #{item.id} Commission"
      )
      store_transfer(ck_transfer)
    end

    fr_transfer = Stripe::Transfer.create(
      amount: self.item.net_amount_cents,
      currency: self.total_currency.downcase,
      recipient: self.recipient.stripe_account.stripe_recipient_id,
      statement_description: "CakeCauseMarketing.com Invoice #{item.id} Transfer"
    )
    store_transfer(fr_transfer)
  end

  def store_transfer(stripe_transfer)
    balance_transaction = Stripe::BalanceTransaction.retrieve(stripe_transfer.balance_transaction)

    self.transfers.build(
      stripe_id: stripe_transfer.id,
      balance_transaction_id: stripe_transfer.balance_transaction,
      kind: stripe_transfer.object,
      amount_cents: stripe_transfer.amount,
      amount_currency: stripe_transfer.currency.upcase,
      total_fee_cents: balance_transaction.fee + Cake::APPLICATION_FEE*stripe_transfer.amount,
      status: stripe_transfer.status
    ).save
  end

  #Balance
  def get_stripe_balance
    balance = Stripe::Balance.retrieve
    balance.available.first.amount = 999999999 if Rails.env.test?
    balance.available.first.amount
  end
end