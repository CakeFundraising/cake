class AddBrowserIdToClicks < ActiveRecord::Migration
  def change
    add_column :clicks, :browser_id, :integer
    remove_column :clicks, :ip
    remove_column :clicks, :user_agent
    remove_column :clicks, :http_encoding
    remove_column :clicks, :http_language
    remove_column :clicks, :browser_plugins
  end
end
