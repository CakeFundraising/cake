class AddGoalToCampaigns < ActiveRecord::Migration
  def change
    add_monetize :campaigns, :goal
  end
end
