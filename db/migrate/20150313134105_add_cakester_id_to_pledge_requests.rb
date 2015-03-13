class AddCakesterIdToPledgeRequests < ActiveRecord::Migration
  def change
    add_column :pledge_requests, :requester_id, :integer
    add_column :pledge_requests, :requester_type, :string
  end
end
