class MakeClickPledgePolymorphic < ActiveRecord::Migration
  def change
    add_column :clicks, :pledge_type, :string
    add_column :quick_pledges, :bonus_clicks_count, :bigint, null: false, default: 0
  end
end
