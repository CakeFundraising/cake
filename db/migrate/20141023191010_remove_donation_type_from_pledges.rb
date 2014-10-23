class RemoveDonationTypeFromPledges < ActiveRecord::Migration
  def change
    remove_column :pledges, :donation_type
  end
end
