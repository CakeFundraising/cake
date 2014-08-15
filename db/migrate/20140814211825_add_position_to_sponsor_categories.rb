class AddPositionToSponsorCategories < ActiveRecord::Migration
  def change
    add_column :sponsor_categories, :position, :integer, default: 0
  end
end
