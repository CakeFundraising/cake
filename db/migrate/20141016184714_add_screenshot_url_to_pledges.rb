class AddScreenshotUrlToPledges < ActiveRecord::Migration
  def change
  	add_column :pledges, :screenshot_url, :string
  end
end
