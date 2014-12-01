class AddFingerprintToBrowsers < ActiveRecord::Migration
  def change
    remove_column :browsers, :ip, :string
    remove_column :browsers, :ua, :string
    remove_column :browsers, :http_language, :string 
    remove_column :browsers, :http_encoding, :string 
    remove_column :browsers, :plugins, :text

    add_column :browsers, :fingerprint, :string
    add_index :browsers, :fingerprint
  end
end
