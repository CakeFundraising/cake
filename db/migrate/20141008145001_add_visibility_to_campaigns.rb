class AddVisibilityToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :visible, :boolean, default: false
  end
end
