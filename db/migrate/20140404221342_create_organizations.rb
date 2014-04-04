class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :avatar
      t.string :name
      t.string :phone
      t.string :website
      t.string :email
      t.integer :user_id

      t.timestamps
    end
  end
end
