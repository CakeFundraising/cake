class ChangeDefaultHeroCampaignsValue < ActiveRecord::Migration
  def change
    change_column :campaigns, :hero, :boolean, default: true
  end
end
