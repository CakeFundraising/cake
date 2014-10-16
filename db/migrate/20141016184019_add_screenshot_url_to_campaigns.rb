class AddScreenshotUrlToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :screenshot_url, :string
  end
end
