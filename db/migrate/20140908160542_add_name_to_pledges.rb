class AddNameToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :name, :string
  end
end
