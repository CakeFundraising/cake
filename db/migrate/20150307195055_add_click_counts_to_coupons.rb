class AddClickCountsToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :clicks_count, :integer, limit: 8, default: 0, null: false
    add_column :coupons, :bonus_clicks_count, :integer, limit: 8, default: 0, null: false
  end
end
