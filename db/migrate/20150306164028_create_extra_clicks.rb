class CreateExtraClicks < ActiveRecord::Migration
  def change
    create_table :extra_clicks do |t|
      t.integer :clickable_id
      t.string :clickable_type
      t.integer  "browser_id"
      t.boolean  "bonus",                  default: false
      t.timestamps
    end
  end
end
