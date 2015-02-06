class AddUrlToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :url, :string
  end
end
