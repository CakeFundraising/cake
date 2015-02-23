class AddFundraiserToDirectDonation < ActiveRecord::Migration
  def change
    add_column :direct_donations, :fundraiser_id, :integer
  end
end
