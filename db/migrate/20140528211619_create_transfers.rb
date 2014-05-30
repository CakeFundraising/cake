class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.string :stripe_id
      t.string :balance_transaction_id
      t.string :kind
      t.money :amount
      t.money :total_fee
      t.string :status
      t.string :transferable_type
      t.integer :transferable_id

      t.timestamps
    end
  end
end
