class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.text :mission
      t.text :customer_demographics
      t.string :manager_name
      t.string :manager_title
      t.string :manager_email
      t.string :manager_phone
      t.string :name
      t.string :phone
      t.string :website
      t.string :email
      t.integer :cause_requirements_mask
      t.integer :scopes_mask
      t.integer :causes_mask
      t.integer :manager_id

      t.timestamps
    end
  end
end
