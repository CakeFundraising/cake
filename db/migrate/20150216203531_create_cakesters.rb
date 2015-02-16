class CreateCakesters < ActiveRecord::Migration
  def change
    create_table :cakesters do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :website
      t.string :manager_name
      t.string :manager_email
      t.string :manager_title
      t.string :manager_phone
      t.text :mission
      t.text :about
      t.integer :causes_mask
      t.integer :scopes_mask
      t.integer :cause_requirements_mask
      t.string :email_subscribers
      t.string :facebook_subscribers
      t.string :twitter_subscribers
      t.string :pinterest_subscribers
      t.integer :manager_id

      t.timestamps null: false
    end
  end
end
