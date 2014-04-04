class CreateFundraiserProfiles < ActiveRecord::Migration
  def change
    create_table :fundraiser_profiles do |t|
      t.string :banner
      t.string :cause
      t.integer :min_pledge
      t.integer :min_click_donation
      t.boolean :donations_kind
      t.boolean :tax_exempt
      t.string :contact_name
      t.string :contact_title
      t.string :contact_email
      t.string :contact_phone
      t.string :name
      t.text :mission
      t.text :supporter_demographic
      t.integer :user_id

      t.timestamps
    end
  end
end
