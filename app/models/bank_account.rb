class BankAccount
  include ActiveModel::Model
  extend ActiveModel::Translation
  attr_accessor :name, :type, :email, :routing_number, :account_number, :token

  validates :name, :email, :type, presence: true  
end