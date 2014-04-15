class CreateFundraisers < ActiveRecord::Migration
  def change
    create_table :fundraisers do |t|
      t.string :cause
      t.integer :min_pledge
      t.integer :min_click_donation
      t.boolean :donations_kind, default: false
      t.boolean :tax_exempt, default: false
      t.boolean :unsolicited_pledges, default: false
      t.string :manager_name
      t.string :manager_title
      t.string :manager_email
      t.string :manager_phone
      t.string :name
      t.text :mission
      t.text :supporter_demographics
      t.string :phone
      t.string :website
      t.string :email
      t.integer :manager_id

      t.timestamps
    end
  end
end
