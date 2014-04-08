class AddFundraisersAndSponsorsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fundraiser_id, :integer
    add_column :users, :sponsor_id, :integer
  end
end
