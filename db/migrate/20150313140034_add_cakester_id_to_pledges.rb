class AddCakesterIdToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :pledge_request_id, :integer
    add_column :pledges, :cakester_id, :integer
  end
end
