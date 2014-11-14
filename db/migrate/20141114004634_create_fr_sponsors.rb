class CreateFrSponsors < ActiveRecord::Migration
  def change
    create_table :fr_sponsors do |t|
      t.string :name
      t.string :email
      t.string :website_url
      t.integer :fundraiser_id

      t.timestamps
    end
  end
end
