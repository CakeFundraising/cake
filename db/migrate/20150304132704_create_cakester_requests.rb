class CreateCakesterRequests < ActiveRecord::Migration
  def change
    create_table :cakester_requests do |t|
      t.integer :cakester_id
      t.integer :fundraiser_id
      t.integer :campaign_id
      t.string :status, default: :pending

      t.timestamps null: false
    end
  end
end
