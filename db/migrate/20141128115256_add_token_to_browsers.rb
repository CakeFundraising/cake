class AddTokenToBrowsers < ActiveRecord::Migration
  def change
    add_column :browsers, :token, :string
    add_index :browsers, :token
  end
end
