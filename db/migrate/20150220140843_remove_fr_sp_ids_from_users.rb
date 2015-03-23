class RemoveFrSpIdsFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :fundraiser_id, :integer
    remove_column :users, :sponsor_id, :integer
  end
end
