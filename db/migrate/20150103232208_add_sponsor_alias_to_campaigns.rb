class AddSponsorAliasToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :sponsor_alias, :string, default: "Sponsors"
  end
end
