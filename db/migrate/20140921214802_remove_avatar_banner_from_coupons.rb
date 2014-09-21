class RemoveAvatarBannerFromCoupons < ActiveRecord::Migration
  def change
    remove_column :coupons, :avatar
    remove_column :coupons, :qrcode
  end
end
