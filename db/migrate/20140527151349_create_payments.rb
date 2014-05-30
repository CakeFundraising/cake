class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.column :total_cents, :bigint
      t.string :total_currency, default:'USD', null: false
      t.string :kind
      t.string :item_type
      t.integer :item_id
      t.string :payer_type
      t.integer :payer_id
      t.string :recipient_type
      t.integer :recipient_id

      t.timestamps
    end
  end
end
