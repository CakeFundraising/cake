class AddStatusToPledges < ActiveRecord::Migration
  def change
    add_column :pledges, :status, :string, default: :pending
  end
end
