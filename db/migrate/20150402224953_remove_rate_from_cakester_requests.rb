class RemoveRateFromCakesterRequests < ActiveRecord::Migration
  def change
    remove_column :cakester_requests, :rate, :integer
  end
end
