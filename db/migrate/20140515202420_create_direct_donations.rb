class CreateDirectDonations < ActiveRecord::Migration
  def change
    create_table :direct_donations do |t|
      t.string :email
      t.string :card_token
      t.integer :campaign_id

      t.timestamps
    end
  end
end
