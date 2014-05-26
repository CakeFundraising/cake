class BankAccount
  include ActiveModel::Model
  attr_accessor :name, :type, :email, :routing_number, :account_number, :token

  validates :name, :email, :type, :token, presence: true  
end