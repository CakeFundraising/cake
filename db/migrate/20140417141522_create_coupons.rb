class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :title
      t.datetime :expires_at
      t.string :promo_code
      t.text :description
      t.text :terms_conditions
      t.string :avatar
      t.string :qrcode
      t.integer :pledge_id

      t.timestamps
    end
  end
end
