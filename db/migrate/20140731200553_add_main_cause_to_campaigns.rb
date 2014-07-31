class AddMainCauseToCampaigns < ActiveRecord::Migration
  def change
    add_column :campaigns, :main_cause, :string
  end
end
