class AddSliToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :type, :string
  end
end
