class CreatePledges < ActiveRecord::Migration
  def change
    create_table :pledges do |t|
      t.string :mission
      t.string :headline
      t.text :description
      t.money :amount_per_click
      t.string :donation_type
      t.money :total_amount
      t.string :website_url
      t.integer :campaign_id
      t.integer :sponsor_id

      t.timestamps
    end
  end
end
