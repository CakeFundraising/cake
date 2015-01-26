class MakeQuickPledgesWithSti < ActiveRecord::Migration
  def change
    drop_table :quick_pledges
    add_column :pledges, :type, :string
  end
end
