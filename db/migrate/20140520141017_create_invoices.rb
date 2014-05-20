class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.column :clicks, :bigint
      t.money :click_donation
      t.column :due_cents, :bigint
      t.string :due_currency
      t.string :status, default: :due_to_pay
      t.integer :pledge_id

      t.timestamps
    end
  end
end