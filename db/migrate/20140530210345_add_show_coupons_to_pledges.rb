class AddShowCouponsToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :show_coupons, :boolean, default: false
  end
end
