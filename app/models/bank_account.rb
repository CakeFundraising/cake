class BankAccount
  include ActiveModel::Model
  attr_accessor :name, :type, :email, :routing_number, :account_number, :token, :tax_id

  validates :name, :email, :type, :token, :tax_id, presence: true

  def update(stripe_account)
    recipient = stripe_account.recipient
    recipient.name = self.name
    recipient.type = self.type.downcase
    recipient.email = self.email
    recipient.tax_id = self.tax_id
    recipient.bank_account = self.token
    recipient.save
  end
end