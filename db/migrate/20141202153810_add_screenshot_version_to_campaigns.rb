class AddScreenshotVersionToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :screenshot_version, :string
  end
end
