class AddScreenshotVersionToPledges < ActiveRecord::Migration
  def change
  	add_column :pledges, :screenshot_version, :string
  end
end
