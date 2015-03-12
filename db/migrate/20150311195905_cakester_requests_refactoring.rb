class CakesterRequestsRefactoring < ActiveRecord::Migration
  def change
    add_column :cakester_requests, :rate, :integer
    add_column :cakester_requests, :message, :text

    remove_column :campaigns, :cakester_id, :integer
  end
end
