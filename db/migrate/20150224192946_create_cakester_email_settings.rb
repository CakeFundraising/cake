class CreateCakesterEmailSettings < ActiveRecord::Migration
  def change
    create_table :cakester_email_settings do |t|
      t.boolean :new_pledge, default: true
      t.boolean :pledge_increased, default: true
      t.boolean :pledge_fully_subscribed, default: true
      t.boolean :campaign_end, default: true
      t.boolean :missed_launch_campaign, default: true
      t.boolean :account_change, default: true
      t.boolean :public_profile_change, default: true
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
