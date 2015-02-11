class CreateSubscriptors < ActiveRecord::Migration
  def change
    create_table :subscriptors do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :object_type
      t.integer :object_id

      t.timestamps null: false
    end
  end
end
