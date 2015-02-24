class CreateCakesterEmailSettings < ActiveRecord::Migration
  def change
    create_table :cakester_email_settings do |t|
      t.boolean :new_pledge
      t.boolean :pledge_increased
      t.boolean :pledge_fully_subscribed
      t.boolean :campaign_end
      t.boolean :missed_launch_campaign
      t.boolean :account_change
      t.boolean :public_profile_change
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
