class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :stripe_id
      t.string :balance_transaction_id
      t.string :kind
      t.money :amount
      t.money :total_fee
      t.boolean :paid
      t.boolean :captured
      t.json :fee_details
      t.string :chargeable_type
      t.integer :chargeable_id

      t.timestamps
    end

    add_index :charges, :stripe_id, unique: true
    add_index :charges, :balance_transaction_id, unique: true
  end
end
