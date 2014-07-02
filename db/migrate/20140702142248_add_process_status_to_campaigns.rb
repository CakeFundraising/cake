class AddProcessStatusToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :processed_status, :string, default: 'unprocessed'
  end
end
