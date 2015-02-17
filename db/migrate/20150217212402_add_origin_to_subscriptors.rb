class AddOriginToSubscriptors < ActiveRecord::Migration
  def change
    add_column :subscriptors, :origin_type, :string
    add_column :subscriptors, :origin_id, :string
  end
end
