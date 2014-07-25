class AddBrowserPropertiesToClicks < ActiveRecord::Migration
  def change
    add_column :clicks, :user_agent, :string
    add_column :clicks, :http_encoding, :string
    add_column :clicks, :http_language, :string
    add_column :clicks, :browser_plugins, :string
  end
end
