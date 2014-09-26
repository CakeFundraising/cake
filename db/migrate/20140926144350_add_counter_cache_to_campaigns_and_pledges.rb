class AddCounterCacheToCampaignsAndPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :impressions_count, :bigint, default: 0
    add_column :campaigns, :impressions_count, :bigint, default: 0
  end
end
