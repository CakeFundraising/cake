class AddBonusClicksCountToPledges < ActiveRecord::Migration
  def self.up
    add_column :pledges, :bonus_clicks_count, :bigint, null: false, default: 0
    #Refactor existing clicks_count
    remove_column :pledges, :clicks_count
    add_column :pledges, :clicks_count, :bigint, null: false, default: 0
  end

  def self.down
    remove_column :pledges, :bonus_clicks_count
    #Refactor existing clicks_count
    remove_column :pledges, :clicks_count
    add_column :pledges, :clicks_count, :bigint, default: 0
  end
end
