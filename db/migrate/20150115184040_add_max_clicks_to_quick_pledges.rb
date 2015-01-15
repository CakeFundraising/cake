class AddMaxClicksToQuickPledges < ActiveRecord::Migration
  def change
    add_column :quick_pledges, :max_clicks, :integer, default: 0
  end
end
