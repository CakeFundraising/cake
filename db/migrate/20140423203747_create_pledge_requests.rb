class CreatePledgeRequests < ActiveRecord::Migration
  def change
    create_table :pledge_requests do |t|
      t.integer :sponsor_id
      t.integer :fundraiser_id
      t.integer :campaign_id
      t.string :status, default: :pending

      t.timestamps
    end
  end
end
