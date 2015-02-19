class MakeRolesPolymorphicInUsers < ActiveRecord::Migration
  def change
    remove_column :users, :fundraiser_id, :integer
    remove_column :users, :sponsor_id, :integer

    add_column :users, :role_type, :string
    add_column :users, :role_id, :integer
  end
end
