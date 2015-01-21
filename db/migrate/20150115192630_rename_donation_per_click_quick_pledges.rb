class RenameDonationPerClickQuickPledges < ActiveRecord::Migration
  def change
    rename_column :quick_pledges, :donation_per_click_cents, :amount_per_click_cents
    rename_column :quick_pledges, :donation_per_click_currency, :amount_per_click_currency
  end
end
