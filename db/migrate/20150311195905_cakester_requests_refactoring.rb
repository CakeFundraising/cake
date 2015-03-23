class CakesterRequestsRefactoring < ActiveRecord::Migration
  def change
    add_column :cakester_requests, :rate, :integer
    add_column :cakester_requests, :message, :text

    rename_column :campaigns, :cakester_id, :exclusive_cakester_id
  end
end
