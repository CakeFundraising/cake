class CreateExtraClick < ActiveRecord::Migration
  def change
    create_table :extra_clicks do |t|
      t.integer :clickable_id
      t.string :clickable_type
      t.integer :browser_id
      t.string :email, limit: 255
      t.boolean :bonus, default: false
      t.timestamps
    end
  end
end
