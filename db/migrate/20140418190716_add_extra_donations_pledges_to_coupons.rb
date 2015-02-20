class AddExtraDonationsPledgesToCoupons < ActiveRecord::Migration
  def change
    add_monetize :coupons, :unit_donation
    add_monetize :coupons, :total_donation
    add_column :coupons, :extra_donation_pledge, :boolean, default: false
  end
end
