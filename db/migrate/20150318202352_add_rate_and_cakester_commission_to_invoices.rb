class AddRateAndCakesterCommissionToInvoices < ActiveRecord::Migration
  def change
    add_monetize :invoices, :net_amount
    add_monetize :invoices, :fees
    add_column :invoices, :cakester_rate, :integer
    add_monetize :invoices, :cakester_commission
  end
end
