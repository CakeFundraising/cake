class BankAccount
  include ActiveModel::Model
  attr_accessor :name, :type, :email, :routing_number, :account_number, :token, :tax_id

  validates :name, :email, :type, :token, :tax_id, presence: true  
end