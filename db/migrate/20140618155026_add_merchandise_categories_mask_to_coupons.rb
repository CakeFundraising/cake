class AddMerchandiseCategoriesMaskToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :merchandise_categories_mask, :integer, limit: 8
  end
end
