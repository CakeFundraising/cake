class AddMissionStatementToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :mission, :text
  end
end
