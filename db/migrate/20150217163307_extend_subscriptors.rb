class ExtendSubscriptors < ActiveRecord::Migration
  def change
    add_column :subscriptors, :phone, :string
    add_column :subscriptors, :organization, :string
    add_column :subscriptors, :message, :text
    remove_column :subscriptors, :first_name, :string
    remove_column :subscriptors, :last_name, :string
    add_column :subscriptors, :name, :string
  end
end
