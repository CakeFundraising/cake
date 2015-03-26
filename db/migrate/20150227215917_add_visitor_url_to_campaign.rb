class AddVisitorUrlToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :visitor_url, :string, default: ""
    add_column :campaigns, :visitor_action, :string, default: ""
  end
end
