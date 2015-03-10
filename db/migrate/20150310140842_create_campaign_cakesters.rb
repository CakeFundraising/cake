class CreateCampaignCakesters < ActiveRecord::Migration
  def change
    create_table :campaign_cakesters do |t|
      t.string :kind
      t.integer :campaign_id
      t.integer :cakester_id
      t.integer :cakester_request_id

      t.timestamps null: false
    end
  end
end
