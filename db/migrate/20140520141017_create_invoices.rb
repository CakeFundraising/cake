class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :clicks
      t.money :click_donation
      t.money :due
      t.string :status, default: :due_to_pay
      t.integer :pledge_id

      t.timestamps
    end
  end
end
