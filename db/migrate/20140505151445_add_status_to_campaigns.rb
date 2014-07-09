class AddStatusToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :status, :string, default: 'not_launched'
  end
end
