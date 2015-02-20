class CreateSponsorCategories < ActiveRecord::Migration
  def change
    create_table :sponsor_categories do |t|
      t.string :name
      t.monetize :min_value
      t.monetize :max_value
      t.integer :campaign_id

      t.timestamps
    end
  end
end
