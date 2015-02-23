class CreatePledgeNews < ActiveRecord::Migration
  def change
    create_table :pledge_news do |t|
      t.string :headline
      t.text :story
      t.string :url
      t.integer :pledge_id

      t.timestamps null: false
    end
  end
end
