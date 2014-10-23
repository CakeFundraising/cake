class ChangeValuesToSponsorCategories < ActiveRecord::Migration
  def change
    change_column :sponsor_categories, :min_value_cents, :bigint, default: 0
    change_column :sponsor_categories, :max_value_cents, :bigint, default: 0
  end
end
