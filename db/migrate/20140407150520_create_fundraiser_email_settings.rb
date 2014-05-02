class CreateFundraiserEmailSettings < ActiveRecord::Migration
  def change
    create_table :fundraiser_email_settings do |t|
      t.boolean :new_pledge, default: false
      t.boolean :pledge_increased, default: false
      t.boolean :pledge_fully_subscribed, default: false
      t.boolean :campaign_end, default: false
      t.boolean :missed_launch_campaign, default: false
      t.boolean :account_change, default: false
      t.boolean :public_profile_change, default: false
      t.integer :user_id

      t.timestamps
    end
  end
end
