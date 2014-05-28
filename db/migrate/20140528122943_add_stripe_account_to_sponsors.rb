class AddStripeAccountToSponsors < ActiveRecord::Migration
  def change
    remove_column :stripe_accounts, :fundraiser_id
    add_column :stripe_accounts, :account_type, :string
    add_column :stripe_accounts, :account_id, :integer
    add_column :stripe_accounts, :customer_id, :string
  end
end
