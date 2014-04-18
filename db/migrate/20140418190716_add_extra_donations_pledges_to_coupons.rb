class AddExtraDonationsPledgesToCoupons < ActiveRecord::Migration
  def change
    add_money :coupons, :unit_donation
    add_money :coupons, :total_donation
    add_column :coupons, :extra_donation_pledge, :boolean, default: false
  end
end
