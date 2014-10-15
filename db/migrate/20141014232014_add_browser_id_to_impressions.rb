class AddBrowserIdToImpressions < ActiveRecord::Migration
  def change
    add_column :impressions, :browser_id, :integer
    remove_column :impressions, :ip
    remove_column :impressions, :user_agent
    remove_column :impressions, :http_encoding
    remove_column :impressions, :http_language
    remove_column :impressions, :browser_plugins
  end
end
