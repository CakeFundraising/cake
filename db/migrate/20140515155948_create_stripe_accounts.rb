class CreateStripeAccounts < ActiveRecord::Migration
  def change
    create_table :stripe_accounts do |t|
      t.string :uid
      t.string :stripe_publishable_key
      t.string :token
      t.integer :fundraiser_id

      t.timestamps
    end

    add_index :stripe_accounts, :uid, unique: true
    
  end
end
