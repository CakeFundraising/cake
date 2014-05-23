class AddRecipientIdToStripeAccounts < ActiveRecord::Migration
  def change
    add_column :stripe_accounts, :stripe_recipient_id, :string
  end
end
