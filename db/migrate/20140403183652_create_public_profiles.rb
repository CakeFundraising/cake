class CreatePublicProfiles < ActiveRecord::Migration
  def change
    create_table :public_profiles do |t|
      t.text :head_line
      t.text :profile_message
      t.text :demographic_description
      t.string :cause
      t.money :min_pledge
      t.money :min_click_donation
      t.boolean :donations_kind
      t.string :name
      t.string :contact_name
      t.string :website
      t.string :phone
      t.string :email
      t.string :banner
      t.string :avatar
      t.integer :user_id

      t.timestamps
    end
  end
end
