class AddClickCountsToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :extra_clicks_count, :integer, limit: 8, default: 0, null: false
    add_column :pledge_news, :extra_clicks_count, :integer, limit: 8, default: 0, null: false
    add_column :fundraisers, :extra_clicks_count, :integer, limit: 8, default: 0, null: false
  end
end
