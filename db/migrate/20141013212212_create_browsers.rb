class CreateBrowsers < ActiveRecord::Migration
  def change
    create_table :browsers do |t|
      t.string  :ip
      t.string  :ua
      t.string  :http_language
      t.string  :http_encoding
      t.text    :plugins
      t.integer :user_id

      t.timestamps
    end
  end
end
