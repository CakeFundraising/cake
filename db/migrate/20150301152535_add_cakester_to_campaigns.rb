class AddCakesterToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :uses_cakester, :boolean, default: false
    add_column :campaigns, :cakester_id, :integer
    add_column :campaigns, :cakester_commission_percentage, :integer
    add_column :campaigns, :any_cakester, :boolean, default: false
  end
end
