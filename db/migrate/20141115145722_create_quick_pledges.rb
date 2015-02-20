class CreateQuickPledges < ActiveRecord::Migration
  def change
    create_table :quick_pledges do |t|
      t.string :name
      t.monetize :donation_per_click
      t.monetize :total_amount
      t.string :website_url
      t.integer :campaign_id
      t.integer :sponsorable_id
      t.string :sponsorable_type
      t.string :status, default: :incomplete
      t.column :clicks_count, :bigint, default: 0
      t.column :impressions_count, :bigint, default: 0

      t.timestamps
    end
  end
end
