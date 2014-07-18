class AddGoalToCampaigns < ActiveRecord::Migration
  def change
    add_money :campaigns, :goal
  end
end
