class CreateImpressions < ActiveRecord::Migration
  def change
    create_table :impressions do |t|
      t.string :impressionable_type
      t.integer :impressionable_id
      t.string :view
      t.string :ip
      t.string :user_agent
      t.string :http_encoding
      t.string :http_language
      t.text :browser_plugins
      t.boolean :fully_rendered, default: false

      t.timestamps
    end
  end
end
