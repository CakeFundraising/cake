class AddHeroToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :hero, :boolean, default: false
  end
end
