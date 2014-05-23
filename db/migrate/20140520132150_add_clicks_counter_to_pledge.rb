class AddClicksCounterToPledge < ActiveRecord::Migration
  def change
    add_column :pledges, :clicks_count, :bigint, default: 0
  end
end
